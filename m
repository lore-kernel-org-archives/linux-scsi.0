From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] scsi device template cleanups
Date: Tue, 5 Nov 2002 18:05:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021105230511.GI13860@linnie.riede.org>
References: <20021105052307.A18575@lst.de>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gA5N5BC03536
	for <linux-scsi@vger.kernel.org>; Tue, 5 Nov 2002 18:05:11 -0500
Content-Disposition: inline
In-Reply-To: <20021105052307.A18575@lst.de>; from hch@lst.de on Mon, Nov 04, 2002 at 23:23:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2002.11.04 23:23 Christoph Hellwig wrote:
> Now that .init isn't implement anymore we can get rid of it and
> do some more cleanup in the scsi device template:
> 
> * remove .blk - unused since 2.5.46
> * remove .dev_noticed, only midlayer user is gone together with
>   .init.  remaining instance now driver-private
> * remove .nr_dev and .dev_max - they're purely driver internal
>   and at least in sd and sr they'll be completly gone very soon.
> 
> 
> ===== drivers/scsi/osst.c 1.23 vs edited =====
> --- 1.23/drivers/scsi/osst.c	Mon Nov  4 12:06:03 2002
> +++ edited/drivers/scsi/osst.c	Tue Nov  5 04:00:30 2002
> @@ -156,6 +156,10 @@
>  static int osst_detect(Scsi_Device *);
>  static void osst_detach(Scsi_Device *);
> 
> +static int osst_dev_noticed;

Actually, after I properly nixed "init", osst doesn't care about
"dev_noticed", so I'm going to nix that too.

Regards, Willem Riede.
