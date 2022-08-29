Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2447C0502C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 16:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiH2Q7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 12:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiH2Q71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 12:59:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BB79A9F0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:59:25 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TGDTiV029779
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:59:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=7qKkKqjCpeQfZrWSEU1vHyAqIlIf1/KcGZa9ucHPGKA=;
 b=GMfTzrn818i3x7lIxxdbt8eXEl6858A2mg2MHEzUAG/N3AOK0T+QJqoPh6TATSSaeL+X
 OqkbJHiEHbAaTOnXqFX9WZ1TbCGXDwbrzvb69i0aFk9rjA4Q1KSBwpU2L0EvmO7Wsq9X
 xbwUUTZ/dQ9rK5fpgAjbERSK43BFOkuT9u5AQFfm/Bk7fMvZhSZ5v/vkZyl/tzQs50za
 mXCxqYKkUPOsiAuCqTdG6PzaI1K82Zy6K9Mx7vAQiLmtKainJb89OW8izN5Sa8166lHr
 Wnbv8sXF+k7P1keNFafXXlbiJrci2OOlDy+WSh8xwd36SVz5LBLVPZmRlgic0a25MlIF DA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j8s2et1mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 09:59:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Aug
 2022 09:59:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Aug 2022 09:59:23 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id C5E8B3F7044;
        Mon, 29 Aug 2022 09:59:23 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 27TGxNKr000318;
        Mon, 29 Aug 2022 09:59:23 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Mon, 29 Aug 2022 09:59:23 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
In-Reply-To: <773B9D53-D043-42D9-B830-694A3E21A222@oracle.com>
Message-ID: <ad348f6e-fec6-1ce5-eed5-621f84a5e580@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
 <773B9D53-D043-42D9-B830-694A3E21A222@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: iCgxmt7VhUPYFI9dTR46n76bseNEhY0Z
X-Proofpoint-ORIG-GUID: iCgxmt7VhUPYFI9dTR46n76bseNEhY0Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_08,2022-08-25_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for reviewing the code, Himanshu. Response inline..

On Mon, 29 Aug 2022, 9:24am, Himanshu Madhani wrote:

> Small nits
> 
> > On Aug 26, 2022, at 3:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
> > 
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > Older tracing of driver messages was to:
> >    - log only debug messages to kernel main trace buffer AND
> >    - log only if extended logging bits corresponding to this
> >      message is off
> > 
> > This has been modified and extended as follows:
> >    - Tracing is now controlled via ql2xextended_error_logging_ktrace
> >      module parameter. Bit usages same as ql2xextended_error_logging.
> >    - Tracing uses "qla2xxx" trace instance, unless instance creation
> >      have issues.
> >    - Tracing is enabled (compile time tunable).
> >    - All driver messages, include debug and log messages are now traced
> >      in kernel trace buffer.
> > 
> > Trace messages can be viewed by looking at the qla2xxx instance at:
> >    /sys/kernel/tracing/instances/qla2xxx/trace
> > 
> ^^^^^^^^
> This should be /sys/kernel/debug/tracing/instances/qla2xxx/trace
> 

With tracefs, the location is moved to:
	/sys/kernel/tracing

..with old location preserved.

Regards,
-Arun
PS: # grep -A 10 '^The File System' Documentation/trace/ftrace.rst
