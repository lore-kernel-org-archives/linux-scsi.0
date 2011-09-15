From: Ravi Shankar <ravi.v.shankar@oracle.com>
Subject: Re: LIO performance Issue
Date: Thu, 15 Sep 2011 12:47:26 -0700
Message-ID: <4E72564E.8000406@oracle.com>
References: <EF8AD1CD95CD1E4DBF423FF61CCFC5A9E4E199860C@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN> <1316031025.12820.95.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30468 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOTrv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2011 15:47:51 -0400
In-Reply-To: <1316031025.12820.95.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Abhilash Sankar - ERS, HCL Tech" <Abhilash.S@hcl.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-iscsi-target-dev@googlegroups.com" <linux-iscsi-target-dev@googlegroups.com>, "Yuvarani C - ERS , HCLTech" <yuvaranic@hcl.com>, "Bagavathy Kumar Mahendran - ERS, HCL Tech" <bagavathykumar.m@hcl.com>, target-devel <target-devel@vger.kernel.org>


>>     
>
> Hi Abhilash,
>
> By default target_core_file.c is using O_SYNC to ensure that WRITEs are
> written directly to disk before acknowledging back to the SCSI client.
> This will have a considerable effect on FILEIO WRITE performance, but is
> done by default to ensure proper data integrity in the face of target
> power loss.
>
> You may want to double check the filp_open() flags with SCST to ensure
> that you are comparing 'apples to apples' here.  Optionally you can try
> disabling O_SYNC with target_core_file.c via rtslib with the class
> FileIOStorageObject:_set_buffered_mode() mentioned here:
>
>   
Another area to consider improvement is how SCSI Target Data phase are 
handled.
The target framework should split SCSI data phases into multiple smaller 
IO to increase
performance. In other work instead of synchronous data phase it need to 
be asynchronous.

--ravi
