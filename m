Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D9AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECD1260551
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhJKNjv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:39:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235762AbhJKNju (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 09:39:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BBDcYq024339;
        Mon, 11 Oct 2021 09:37:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Vh9Ax3wGaML7aLzdHacchlLErNzlABDxZ+us9NMNqLI=;
 b=HKu24wUI4BfGwGXJkYsDGm+yDjGc/aSTQjmFDYtObpqhZVcBJ51eTIYBvvncs9gtavKX
 QCPDCpIXXw3X6tijQ0yVHsH5EDaO1bZZUkKrdv9lEsTmwBpiIEuXjYEhFndJW0A7mIsi
 D680ckuJLL/IRu4LAFoS6ZS1fPi1ot7Nyv975vwykSeB/QyUlYM1pcrHMOZhCyIsRQln
 jD2t5XW3Fsc0r1rgRVATYYBhXDc0D6Oxk+cRiwH04rqkTZn7lELkc5YkEBJhBotBFHJ7
 rQ/TD7BKy5ewMf/dAYnT5QK4Mt+5BoxwOBaXpjEamvYEEZJwTw+Tf3MYnNrSkBcTStD3 qw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmhhuy936-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 09:37:44 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BDRmsg030721;
        Mon, 11 Oct 2021 13:37:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bhxbag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 13:37:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BDbc5e4129498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 13:37:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 781FD4204B;
        Mon, 11 Oct 2021 13:37:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 654F24203F;
        Mon, 11 Oct 2021 13:37:38 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.35.184])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Oct 2021 13:37:38 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mZvUn-005Hra-Tj; Mon, 11 Oct 2021 15:37:37 +0200
Date:   Mon, 11 Oct 2021 15:37:37 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 01/46] scsi: core: Register sysfs attributes earlier
Message-ID: <YWQ+IeaiO1Yb3xa1@t480-pf1aa2c2.linux.ibm.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-2-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20211008202353.1448570-2-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2mFj0DWs5-wXqKjMpJGQuyKzG-IsmMJL
X-Proofpoint-GUID: 2mFj0DWs5-wXqKjMpJGQuyKzG-IsmMJL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 malwarescore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110078
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 08, 2021 at 01:23:08PM -0700, Bart Van Assche wrote:
> A quote from Documentation/driver-api/driver-model/device.rst:
> "Word of warning:  While the kernel allows device_create_file() and
> device_remove_file() to be called on a device at any time, userspace has
> strict expectations on when attributes get created.  When a new device is
> registered in the kernel, a uevent is generated to notify userspace (like
> udev) that a new device is available.  If attributes are added after the
> device is registered, then userspace won't get notified and userspace will
> not know about the new attributes."
> 
> Hence register SCSI host sysfs attributes before the SCSI host shost_dev
> uevent is emitted instead of after that event has been emitted.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/hosts.c       | 23 ++++++++++-
>  drivers/scsi/scsi_priv.h   |  4 +-
>  drivers/scsi/scsi_sysfs.c  | 81 +++++++++++++++++++-------------------
>  include/scsi/scsi_device.h |  7 ++++
>  include/scsi/scsi_host.h   | 12 ++++++
>  5 files changed, 84 insertions(+), 43 deletions(-)
> 

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
