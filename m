From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 08:33:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227163341.GB1424@beaverton.ibm.com>
References: <20040226235412.GA819@phunnypharm.org> <20040226171928.750f5f6f.akpm@osdl.org> <20040226173743.2bf473b4.akpm@osdl.org> <20040227030428.GA707@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:18656 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263039AbUB0Qef
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 11:34:35 -0500
Content-Disposition: inline
In-Reply-To: <20040227030428.GA707@phunnypharm.org>
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Ben Collins [bcollins@debian.org] wrote:
>  static void scsi_host_cls_release(struct class_device *class_dev)
>  {
> +	down(&host_num_lock);
> +	idr_remove(&allocated_hosts, class_to_shost(class_dev)->host_no);
> +	up(&host_num_lock);
>  	put_device(&class_to_shost(class_dev)->shost_gendev);
>  }
>  

Should the idr_remove be done in scsi_host_dev_release instead? We
really should not make this number available until everyone is done with
this host.

-andmike
--
Michael Anderson
andmike@us.ibm.com

