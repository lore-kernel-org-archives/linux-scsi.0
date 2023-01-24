Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91550C38142
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 14:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjAXOGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 09:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjAXOGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 09:06:50 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E3B2C644
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 06:06:33 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OCktXT017624;
        Tue, 24 Jan 2023 13:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=za/AuMOGio28MFzl3xaLmqujZPkw/ngCvojbndx18Po=;
 b=KPYKhMBIOpdPb1TPFxWaBDACnqMEnEuV5R8+QNVdfAkCxSUPBLChQVT8eRfVYJHvCNkX
 qW0X0fNcJDGt311edmbiLw/JUBQTVmxTEIY5ODTidTtiqxNqOFZ7exPd04hUPCoslO9Y
 Ve9DPH/YA6S1JcNgYTPhSfBO90dGZnY5ebnkpCvKRiDeWLltrVPXlL2riRrYU63xwgLd
 8JBDkTfciBUf4+MJRrMyhcz0I27V5C/7JOfkxv+Pc4LkFqkQ9Q+SfhY78k05GEnoKhXr
 cV3p2N7YZVmMDulTWd47DoK9Q8S+QhXqhSMDs/fiA1O8rtIoG1ZMDiPR/mQDgmGWpvkC Lw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3naaru8g26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 13:48:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30OCUWWu005785;
        Tue, 24 Jan 2023 13:48:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n87p6as2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 13:48:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30ODmLWc37159204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 13:48:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA97920040;
        Tue, 24 Jan 2023 13:48:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7035520043;
        Tue, 24 Jan 2023 13:48:21 +0000 (GMT)
Received: from [9.152.212.243] (unknown [9.152.212.243])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 24 Jan 2023 13:48:21 +0000 (GMT)
Message-ID: <794bc473-291b-9780-342a-6a74035b7dd7@linux.ibm.com>
Date:   Tue, 24 Jan 2023 14:48:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: add non-sleeping variant of scsi_device_put() and
 use it in alua
Content-Language: en-US
To:     mwilck@suse.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20230124120734.15806-1-mwilck@suse.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20230124120734.15806-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vRMAUwzJ2AGDzClQRsqIa_QRvi34A1u2
X-Proofpoint-ORIG-GUID: vRMAUwzJ2AGDzClQRsqIa_QRvi34A1u2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 13:07, mwilck@suse.com wrote:
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1426b9b03612..eec52bb298a7 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -576,6 +576,24 @@ int scsi_device_get(struct scsi_device *sdev)
>   }
>   EXPORT_SYMBOL(scsi_device_get);
>   
> +/**
> + * scsi_device_put_nosleep  -  release a reference to a scsi_device
> + * @sdev:	device to release a reference on.
> + *
> + * Description: Release a reference to the scsi_device and decrements the use
> + * count of the underlying LLDD module. This function may only be called from
> + * a call context where it is certain that the reference dropped is not the
> + * last one.
> + */
> +void scsi_device_put_nosleep(struct scsi_device *sdev)
> +{
> +	struct module *mod = sdev->host->hostt->module;
> +
> +	put_device(&sdev->sdev_gendev);
> +	module_put(mod);
> +}
> +EXPORT_SYMBOL(scsi_device_put);

+EXPORT_SYMBOL(scsi_device_put_nosleep);


otherwise I get:

>   CC [M]  drivers/scsi/scsi.o
> In file included from ./include/linux/linkage.h:7,
>                  from ./include/linux/preempt.h:10,
>                  from ./arch/s390/include/asm/timex.h:13,
>                  from ./include/linux/timex.h:67,
>                  from ./include/linux/time32.h:13,
>                  from ./include/linux/time.h:60,
>                  from ./include/linux/stat.h:19,
>                  from ./include/linux/module.h:13,
>                  from drivers/scsi/scsi.c:41:
> ./include/linux/export.h:57:43: error: redefinition of ‘__ksymtab_scsi_device_put’
>    57 |         static const struct kernel_symbol __ksymtab_##sym               \
>       |                                           ^~~~~~~~~~
> ./include/linux/export.h:96:9: note: in expansion of macro ‘__KSYMTAB_ENTRY’
>    96 |         __KSYMTAB_ENTRY(sym, sec)
>       |         ^~~~~~~~~~~~~~~
> ./include/linux/export.h:140:41: note: in expansion of macro ‘___EXPORT_SYMBOL’
>   140 | #define __EXPORT_SYMBOL(sym, sec, ns)   ___EXPORT_SYMBOL(sym, sec, ns)
>       |                                         ^~~~~~~~~~~~~~~~
> ./include/linux/export.h:147:41: note: in expansion of macro ‘__EXPORT_SYMBOL’
>   147 | #define _EXPORT_SYMBOL(sym, sec)        __EXPORT_SYMBOL(sym, sec, "")
>       |                                         ^~~~~~~~~~~~~~~
> ./include/linux/export.h:150:41: note: in expansion of macro ‘_EXPORT_SYMBOL’
>   150 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
>       |                                         ^~~~~~~~~~~~~~
> drivers/scsi/scsi.c:611:1: note: in expansion of macro ‘EXPORT_SYMBOL’
>   611 | EXPORT_SYMBOL(scsi_device_put);
>       | ^~~~~~~~~~~~~
> ./include/linux/export.h:57:43: note: previous definition of ‘__ksymtab_scsi_device_put’ with type ‘const struct kernel_symbol’
>    57 |         static const struct kernel_symbol __ksymtab_##sym               \
>       |                                           ^~~~~~~~~~
> ./include/linux/export.h:96:9: note: in expansion of macro ‘__KSYMTAB_ENTRY’
>    96 |         __KSYMTAB_ENTRY(sym, sec)
>       |         ^~~~~~~~~~~~~~~
> ./include/linux/export.h:140:41: note: in expansion of macro ‘___EXPORT_SYMBOL’
>   140 | #define __EXPORT_SYMBOL(sym, sec, ns)   ___EXPORT_SYMBOL(sym, sec, ns)
>       |                                         ^~~~~~~~~~~~~~~~
> ./include/linux/export.h:147:41: note: in expansion of macro ‘__EXPORT_SYMBOL’
>   147 | #define _EXPORT_SYMBOL(sym, sec)        __EXPORT_SYMBOL(sym, sec, "")
>       |                                         ^~~~~~~~~~~~~~~
> ./include/linux/export.h:150:41: note: in expansion of macro ‘_EXPORT_SYMBOL’
>   150 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
>       |                                         ^~~~~~~~~~~~~~
> drivers/scsi/scsi.c:595:1: note: in expansion of macro ‘EXPORT_SYMBOL’
>   595 | EXPORT_SYMBOL(scsi_device_put);
>       | ^~~~~~~~~~~~~



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

