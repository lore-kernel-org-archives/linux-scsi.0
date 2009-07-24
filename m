From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB
 Disks
Date: Fri, 24 Jul 2009 13:55:42 +0300
Message-ID: <4A69932E.90906@turknet.net.tr>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752768AbZGXKzq@vger.kernel.org>
In-Reply-To: <yq1fxdji03l.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On 06/29/2009 05:30 PM, Martin K. Petersen wrote:
> Tarkan>  version=0x00 [no conformance claimed]
>
> Wow, that's super lame.  And somewhat odd because WDC are usually pretty
> good at USB-SATA bridge protocol compliance.  But in any case this is
> unrelated to your problems.
>
> My concern was that our recent changes to the capacity detection in SCSI
> failed for your device.  However, given your attached log it looks like
> it's a USB issue.  And rereading your original log it also looks like
> you had a USB timeout which coincided with READ CAPACITY failing.
>
> So I'm deferring to the USB folks.
>
> Tarkan>  [160848.805027] usb 5-8: reset high speed USB device using
> Tarkan>  ehci_hcd and address 7
>
>    

Martin,

Today, I had time to bisect and you were right: The below commit related 
to capacity detection changes in SCSI subsystem,as you mentioned, seems 
the cause of the problem.

3821d768912a47ddbd6cab52943a8284df88003c is first bad commit
commit 3821d768912a47ddbd6cab52943a8284df88003c
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Sat May 23 11:43:38 2009 -0400

     sd: Detect non-rotational devices

     Detect non-rotational devices and set the queue flag accordingly.

     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 f744f08d73f56e6d8461267c8c5bc4c710d4c9dd 
89eb1f56a7066a22a9ae6b7b916453a78a9dd082 M      drivers
