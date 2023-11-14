Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B271BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 16:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjKNQEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 11:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjKNQEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 11:04:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478F131
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 08:04:48 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEFlsFJ023121;
        Tue, 14 Nov 2023 16:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kL8Hh7TUproyx7o1cBXBcYWRPNExy5LOmfFSXKWiqwI=;
 b=CuwD+IP716Iu/T5hPXzYAKEYr0iKlpcZMFy6okRvP4hBqQXtKx35iZspiW7EpoKnMkQk
 cFDaplNQ4yVvuKHkzOsjB4iEKWMyFUS6mEtdpeoQdIs2RP/ODEHV7bJdMC6b9iU70Ex2
 gd+NqDF/0DTibrDs/LajxjxGKbHKX+I+NCWrgdv1RdlDWNhFaaudnWmqPTv7RfPRiruK
 e3i472yJTKVlaD8BeKD3YkaEgXgS4kcggsKLa1XEjUgZAWtE4K2Hc6tOyfDTDC//B9gs
 g270Dw6lgcESbQlBr5/k051cYvpCAGR4YKn5QrasVFNnAoVqSNXNxiAMo50WNg0yPWer LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ucbuf8m5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Nov 2023 16:04:37 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AEFoojl000701;
        Tue, 14 Nov 2023 16:04:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ucbuf8m52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Nov 2023 16:04:37 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEE4Tmv011022;
        Tue, 14 Nov 2023 16:04:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uapn1ge95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Nov 2023 16:04:36 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AEG4YGJ12517916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 16:04:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AAB92004B;
        Tue, 14 Nov 2023 16:04:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A17F20043;
        Tue, 14 Nov 2023 16:04:34 +0000 (GMT)
Received: from [9.152.212.249] (unknown [9.152.212.249])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Nov 2023 16:04:34 +0000 (GMT)
Message-ID: <215e3415-94da-4e77-b2ed-374e91effeac@linux.ibm.com>
Date:   Tue, 14 Nov 2023 17:04:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers: fix typo in drivers/scsi/st.c
To:     zilong zhang <NeoPerceval@outlook.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, trivial@kernel.org
References: <SEYPR03MB6507111C9AF0BBE744EA7841A2B2A@SEYPR03MB6507.apcprd03.prod.outlook.com>
Content-Language: en-US
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <SEYPR03MB6507111C9AF0BBE744EA7841A2B2A@SEYPR03MB6507.apcprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ErBycK16feDMbEg-XI5juZNzh7oB264E
X-Proofpoint-GUID: REF7lPnnR14FalwOVdwq4QAwLbBhHWyS
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_16,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311140123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/23 15:33, zilong zhang wrote:
> Replace invisible character with a space.
> The diff looks like this on my terminal:
> 
> -^L

Could those have been intentional form feeds for some code formatting or 
printing or editing tools?
https://en.wikipedia.org/wiki/Page_break#Form_feed

> +
> 
> Signed-off-by: zilong zhang <NeoPerceval@outlook.com>
> ---
>   drivers/scsi/st.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 338aa8c42968..19d86257036d 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -230,7 +230,7 @@ static DEFINE_SPINLOCK(st_use_lock);
>   static DEFINE_IDR(st_index_idr);
> 
> 
> -
> +
>   #ifndef SIGS_FROM_OSST
>   #define SIGS_FROM_OSST \
>   	{"OnStream", "SC-", "", "osst"}, \
> @@ -308,7 +308,7 @@ static char * st_incompatible(struct scsi_device* SDp)
>   		}
>   	return NULL;
>   }
> -
> +
> 
>   #define st_printk(prefix, t, fmt, a...) \
>   	sdev_prefix_printk(prefix, (t)->device, (t)->name, fmt, ##a)
> @@ -880,7 +880,7 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
>   	return result;
> 
>   }
> -
> +
>   /* Set the mode parameters */
>   static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
>   {
> @@ -955,7 +955,7 @@ static void reset_state(struct scsi_tape *STp)
>   		STp->new_partition = STp->partition;
>   	}
>   }
> -
> +
>   /* Test if the drive is ready. Returns either one of the codes below or a negative system
>      error code. */
>   #define CHKRES_READY       0
> @@ -1244,7 +1244,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
>   }
> 
> 
> -/* Open the device. Needs to take the BKL only because of incrementing the SCSI host
> +/* Open the device. Needs to take the BKL only because of incrementing the SCSI host
>      module count. */
>   static int st_open(struct inode *inode, struct file *filp)
>   {
> @@ -1337,7 +1337,7 @@ static int st_open(struct inode *inode, struct file *filp)
>   	return retval;
> 
>   }
> -
> +
> 
>   /* Flush the tape buffer before close */
>   static int st_flush(struct file *filp, fl_owner_t id)
> @@ -1891,7 +1891,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
> 
>   	return retval;
>   }
> -
> +
>   /* Read data from the tape. Returns zero in the normal case, one if the
>      eof status has changed, and the negative error code in case of a
>      fatal error. Otherwise updates the buffer and the eof state.
> @@ -2090,7 +2090,7 @@ static long read_tape(struct scsi_tape *STp, long count,
>   	}
>   	return retval;
>   }
> -
> +
> 
>   /* Read command */
>   static ssize_t
> @@ -2238,7 +2238,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
> 
>   	return retval;
>   }
> -
> +
> 
> 
>   DEB(
> @@ -2452,7 +2452,7 @@ static int st_set_options(struct scsi_tape *STp, long options)
> 
>   	return 0;
>   }
> -
> +
>   #define MODE_HEADER_LENGTH  4
> 
>   /* Mode header and page byte offsets */
> @@ -2670,7 +2670,7 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
> 
>   	return retval;
>   }
> -
> +
>   #if DEBUG
>   #define ST_DEB_FORWARD  0
>   #define ST_DEB_BACKWARD 1
> @@ -3096,7 +3096,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
> 
>   	return ioctl_result;
>   }
> -
> +
> 
>   /* Get the tape position. If bt == 2, arg points into a kernel space mt_loc
>      structure. */
> @@ -3288,7 +3288,7 @@ static int switch_partition(struct scsi_tape *STp)
>   		STps->last_block_visited = 0;
>   	return set_location(STp, STps->last_block_visited, STp->new_partition, 1);
>   }
> -
> +
>   /* Functions for reading and writing the medium partition mode page. */
> 
>   #define PART_PAGE   0x11
> @@ -3496,7 +3496,7 @@ static int partition_tape(struct scsi_tape *STp, int size)
>   out:
>   	return result;
>   }
> -
> +
> 
> 
>   /* The ioctl command */
> @@ -3864,7 +3864,7 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd_in, unsigned lon
>   }
>   #endif
> 
> -
> +
> 
>   /* Try to allocate a new tape buffer. Calling function must not hold
>      dev_arr_lock. */

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

