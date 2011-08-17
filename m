From: Ravi Shankar <ravi.v.shankar@oracle.com>
Subject: Re: mpt2sas driver behaving strange with a failed SATA disk behind
 SAS expander.
Date: Wed, 17 Aug 2011 11:35:00 -0700
Message-ID: <4E4C09D4.3020702@oracle.com>
References: <4E4BCF54.8090408@swip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:29081 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1HQSfK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 14:35:10 -0400
Received: from rtcsinet21.oracle.com (rtcsinet21.oracle.com [66.248.204.29])
	by acsinet15.oracle.com (Switch-3.4.4/Switch-3.4.4) with ESMTP id p7HIZ7PV021608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 18:35:10 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by rtcsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id p7HIZ6tr019556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 18:35:07 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id p7HIZ0JJ005235
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 13:35:00 -0500
In-Reply-To: <4E4BCF54.8090408@swip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/17/11 07:25, Fredrik Lindgren wrote:
> Hello,
>
> I'm seeing something strange on a Supermicro 847E16-R1400. It has SAS 
> expanders
> with SATA disks behind them (Seagate Barracuda XT). The SAS card is a 
> LSI SAS9211-8i.
>
> When doing disk IO on the disks (they are all configured in MD raids) 
> suddenly IO will
> stop and these messages are printed on the console about once every 
> second:
>
> mpt2sas0: log_info(0x31110610): originator(PL), code(0x11), 
> sub_code(0x0610)
>
> From what I understand this means:
>
> PL_LOGINFO_CODE_RESET (0x00110000)
> PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET (0x00000600)
>
> So a disk is acting up, generating errors? What does the last "10" 
> mean in the sub_code,
> is that an identifier for which disk it is?
>
> After some time, the message changed:
>
> mpt2sas0: log info(0x31111000): originator(PL), code(0x11), sub 
> code(0x1000)
>
> Now the disk seems to have died completely?
>
> PL_LOGINFO_CODE_RESET (0x00110000)
> PL_LOGINFO_SUB_CODE_DSCVRY_SATA_INIT_TIMEOUT (0x00001000)
>
I think sub code (0x610) indicates "Error in SATA ReadLogExt SATA 
command" and subsequently the disk drive failed
to initialize (SATA initialization timeout). Since you've connected 
through Expander, the link between Disk and Expander
should be actively transmitting FIS frames. You can verify whether Disk 
link is up by checking Expander Routing Tables.

Reduce the link speed (from 6 to 3 Gb/s) between HBA-Exp-Disk and try 
disabling Native Cmd Queuing and see whether it helps.
