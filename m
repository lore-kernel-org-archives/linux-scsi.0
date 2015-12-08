From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 108771] scsi: ses: kasan: ses_enclosure_data_process use
 after free on boot SAS2X28
Date: Tue, 08 Dec 2015 08:16:26 -0800
Message-ID: <1449591386.2219.5.camel@HansenPartnership.com>
References: <bug-108771-11613@https.bugzilla.kernel.org/>
	 <bug-108771-11613-NEJGozmw2J@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757001AbbLHQQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2015 11:16:28 -0500
In-Reply-To: <bug-108771-11613-NEJGozmw2J@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2015-12-07 at 14:01 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=108771
> 
> --- Comment #1 from Pavel Tikhomirov <ptikhomirov@virtuozzo.com> ---
> Aditional info about enclosue(from that node, but older 3.10 based kernel):
> 
> [root@p9 crash]# modprobe sg
> [root@p9 crash]#  sg_map -i
> /dev/sg0  LSI       SAS2X28           0e12
> /dev/sg1  /dev/sda  LSI  MR9260-4i  2.13
> [root@p9 crash]# lsscsi -gs
> [1:0:16:0]   enclosu LSI      SAS2X28          0e12  -          /dev/sg0       
> -
> [1:2:0:0]    disk    LSI      MR9260-4i        2.13  /dev/sda   /dev/sg1  
> 3.99TB
> [root@p9 crash]#  sg_ses /dev/sg0
>   LSI       SAS2X28           0e12
> Supported diagnostic pages:
>   Supported Diagnostic Pages [sdp] [0x0]
>   Configuration (SES) [cf] [0x1]
>   Enclosure Status/Control (SES) [ec,es] [0x2]
>   Element Descriptor (SES) [ed] [0x7]
>   Additional Element Status (SES-2) [aes] [0xa]
>   Download Microcode (SES-2) [dm] [0xe]
> [root@p9 crash]#  sg_ses /dev/sg1
>   LSI  MR9260-4i  2.13
>     disk device (not an enclosure)
> Supported diagnostic pages:

OK, can you give us the contents of pages 1, 2 and 10 with

sg_ses --page=1 --hex /dev/sg0
sg_ses --page=2 --hex /dev/sg0
sg_ses --page=10 --hex /dev/sg0

The version of the kernel you do this on doesn't really matter.

Thanks,

James


