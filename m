From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
Date: Mon, 27 Jul 2009 11:27:08 +0300
Message-ID: <4A6D64DC.3020001@panasas.com>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>	<yq1hbwykj80.fsf@sermon.lab.mkp.net>	<20090727020611.GC3711@parisc-linux.org> <yq18wiakfq4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:17583
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754980AbZG0I1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2009 04:27:18 -0400
In-Reply-To: <yq18wiakfq4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tarkan Erimer <tarkan.erimer@turknet.net.tr>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/27/2009 05:43 AM, Martin K. Petersen wrote:
>>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:
> 
> First let's see if I actually interpreted the responses correctly and
> that this fixes the issue.
> 
> Matthew> and the sd code seems to check for that.  So what bug are you
> Matthew> papering over here?
> 
> The USB drive in question appears to go tits up when we send it an
> extended inquiry.  I contemplated adding a BLIST option but we really
> only need EVPD to access pages 0xB0 and 0xB1.  

I don't understand. The device in question breaks when we try to read
a page that it reported it supports? we did do
        /* Ask for all the pages supported by this device */
        result = scsi_vpd_inquiry(sdev, buf, 0, 255);
        if (result)
                goto fail;
Didn't we? Are we checking that 0xB0 or 0xB1 are returned?

The Block Limits page
> appeared in SBC2 so I'm just trying to play it safe.  And hopefully fix
> Tarkan's problem in the process.
> 

Thanks
Boaz
