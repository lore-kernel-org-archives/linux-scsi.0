From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: LIO performance Issue
Date: Wed, 14 Sep 2011 13:10:25 -0700
Message-ID: <1316031025.12820.95.camel@haakon2.linux-iscsi.org>
References: <EF8AD1CD95CD1E4DBF423FF61CCFC5A9E4E199860C@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39960 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab1INUKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2011 16:10:41 -0400
In-Reply-To: <EF8AD1CD95CD1E4DBF423FF61CCFC5A9E4E199860C@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Abhilash  Sankar - ERS, HCL Tech" <Abhilash.S@hcl.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-iscsi-target-dev@googlegroups.com" <linux-iscsi-target-dev@googlegroups.com>, "Yuvarani C - ERS , HCLTech" <yuvaranic@hcl.com>, "Bagavathy Kumar Mahendran - ERS, HCL Tech" <bagavathykumar.m@hcl.com>, target-devel <target-devel@vger.kernel.org>

On Wed, 2011-09-14 at 19:30 +0530, Abhilash Sankar - ERS, HCL Tech
wrote:
> Hi all,
> 
> My name is Abhilash, I am new to this community, I am trying to do a performance study of LIO-iSCSI and SCST using robocopy (I/O Tool).
> I have successfully ported LIO to my Debian OS. Based on my initial analysis, SCST had shown a better write performance than LIO.
> 
> Read performance seems to be almost similar for both the stack. But write performance for file based LIO-iSCSI has degraded more than 50%
> while compared to SCST stack in my setup.
> 
> I am using LIO 4.0, file based IO and Windows 7 initiator.
> 
> It would be much helpful if anyone could give me some suggestion to improve the LIO write performance.
> 

Hi Abhilash,

By default target_core_file.c is using O_SYNC to ensure that WRITEs are
written directly to disk before acknowledging back to the SCSI client.
This will have a considerable effect on FILEIO WRITE performance, but is
done by default to ensure proper data integrity in the face of target
power loss.

You may want to double check the filp_open() flags with SCST to ensure
that you are comparing 'apples to apples' here.  Optionally you can try
disabling O_SYNC with target_core_file.c via rtslib with the class
FileIOStorageObject:_set_buffered_mode() mentioned here:

http://www.risingtidesystems.com/git/?p=rtslib.git;a=blob;f=rtslib/tcm.py;h=4da49b0f4a4aea9a1eebed23d457181085a2d03d;hb=HEAD#l975

--nab

