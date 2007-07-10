From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Linux 2.6.22 released
Date: Tue, 10 Jul 2007 14:41:50 -0400
Message-ID: <4693D2EE.3020401@redhat.com>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <20070709111431.2fd3fba9@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763535AbXGJSmp@vger.kernel.org>
In-Reply-To: <20070709111431.2fd3fba9@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/09/2007 06:14 AM, Alan Cox wrote:
> Are the shortlogs useful - yes .. they catch what appear to be mistakes
> 
> Specifically: What happened to the aacraid ioctl security fix ? Did someone decide it
> wasn't needed or did it get lost somewhere on the way ?
> 
> While this looks scary the only obvious exploit cases are where the user can
> open a device level file on an AACraid. Very few people put scanners or CD
> devices on one so the actual impact is probably minimal.

I can't find that patch in any SCSI git tree.

> --- drivers/scsi/aacraid/linit.c~	2007-07-09 10:51:55.653223304 +0100
> +++ drivers/scsi/aacraid/linit.c	2007-07-09 10:51:55.653223304 +0100
> @@ -453,6 +453,8 @@
>  static int aac_ioctl(struct scsi_device *sdev, int cmd, void __user * arg)
>  {
>  	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
