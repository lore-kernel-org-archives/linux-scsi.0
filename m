From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] lpfc: Fix possible use-after-free and double free in
 lpfc_mbx_cmpl_rdp_page_a2()
Date: Mon, 17 Aug 2015 23:26:34 +0200
Message-ID: <20150817232634.00006d80@localhost>
References: <1439809382-32419-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439809382-32419-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Colin King <colin.king@canonical.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Johannes Thumshirn wrote:
> If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, execution
> continues normally and mp gets kfree()d.
> 
> If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps to the
> error label where lpfc_mbuf_free() is called with mp->virt and mp->phys as
> function arguments. This is the use after free. Following the use after free mp
> gets kfree()d again which is a double free.

A similar patch was posted by Colin Ian King on 2015-07-31 [1].

[1] http://marc.info/?l=linux-scsi&m=143835937206204&w=2

Sebastian
