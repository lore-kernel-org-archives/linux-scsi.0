Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140E5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E97E960F6E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbhJKNkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:40:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235762AbhJKNkL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 09:40:11 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BDabtc011941;
        Mon, 11 Oct 2021 09:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DYLtP39RRa26ALuIsIaEUjoeyw9lPZZ3qwVAAAFkpHI=;
 b=VpTRz3pywXZk7tp0X3wkyYFYm4ckg6pVPlfk0fxXD7VfXqUIwCTBxYlfM4OCgEaAl2KT
 q466G4SMnTNHgDfreVF7D4fqk523raBi8dJZv5V1Vu6EFF1LTUXvUeLKfvViXUuCGtXY
 pQxJ5T+ViV/KauippewOg19BzCh/qA+xOAvmTbRdE/2rJ9JEvuXqpOVmpMqqq+jZGA08
 EID8QsVUyot1NZQAJgxafScDIGZ7pyvp/hnGUtRUUpMOozqpPFDb06ldD8oAjNsmVG5/
 r0pDAa+mVTx9ZHbuLOXYCbQh465wB0vDVGHR6QGq2SCMCxm8BDoqWunAylVXnJEmsNkR Hg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bmhdbyaen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 09:38:06 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BDbJtC001462;
        Mon, 11 Oct 2021 13:38:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3bk2q9n2pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 13:38:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BDc1mI32899446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 13:38:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 682CEA4068;
        Mon, 11 Oct 2021 13:38:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51EA5A4066;
        Mon, 11 Oct 2021 13:38:01 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.35.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Oct 2021 13:38:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mZvVA-005HsJ-NL; Mon, 11 Oct 2021 15:38:00 +0200
Date:   Mon, 11 Oct 2021 15:38:00 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 46/46] scsi: core: Remove two host template members
 that are no longer used
Message-ID: <YWQ+OMa8OiaRiNGx@t480-pf1aa2c2.linux.ibm.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-47-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20211008202353.1448570-47-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7_6zEczJOxMcXRJo3AhpRR5ARvLKK0Nd
X-Proofpoint-ORIG-GUID: 7_6zEczJOxMcXRJo3AhpRR5ARvLKK0Nd
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110078
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 08, 2021 at 01:23:53PM -0700, Bart Van Assche wrote:
> All SCSI drivers have been converted to use shost_groups and sdev_groups
> instead of shost_attrs or sdev_attrs. Hence remove shost_attrs and
> sdev_attrs.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/hosts.c       |  9 ---------
>  drivers/scsi/scsi_priv.h   |  2 --
>  drivers/scsi/scsi_sysfs.c  | 28 ----------------------------
>  include/scsi/scsi_device.h |  1 -
>  include/scsi/scsi_host.h   | 11 -----------
>  5 files changed, 51 deletions(-)
> 

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
