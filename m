From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 13/17] hpsa: Retry driver initiated commands on unit
 attention
Date: Thu, 12 Nov 2009 14:52:48 -0800
Message-ID: <20091112145248.35c76f52.akpm@linux-foundation.org>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
	<20091111165129.17754.71091.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754859AbZKLWwy@vger.kernel.org>
In-Reply-To: <20091111165129.17754.71091.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 11 Nov 2009 10:51:29 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> +static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
> +	struct CommandList *c, int data_direction)
> +{
> +	int retry_count = 0;
> +
> +	do {
> +		memset(c->err_info, 0, sizeof(c->err_info));
> +		hpsa_scsi_do_simple_cmd_core(h, c);
> +		retry_count++;
> +	} while (check_for_unit_attention(h, c) && retry_count <= 3);
> +	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
> +}

If this times out, no indication of the error is returned to the caller
and no message is displayed to the operator.

Doesn't seem very robust?
