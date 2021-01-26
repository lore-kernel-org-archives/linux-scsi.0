Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB63C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 17:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF362083E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 17:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390649AbhAZRTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:19:41 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:43094 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389340AbhAZJOf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Jan 2021 04:14:35 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7BBE041306;
        Tue, 26 Jan 2021 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1611652425;
         x=1613466826; bh=pAwTHpdgiRj9rF1GL0yAcUFqatPELVV254k99kwCScg=; b=
        aSMXm7DZMBYY2TwO97yWNjk0+nb/e/4Al0UkAdTiONrJn3vV3kJXXJIVvHSgFRjU
        u7hTiIwAJYOp0KgYNVa5MK/raWOd2VR2kbQMx374onBxFPT6JtWqePue5ETttjd2
        l3M7vVSSk0x3fLaT1vKVqPl2dSkgoSACqHsuAhJiPqw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NlMHm_nbvn1d; Tue, 26 Jan 2021 12:13:45 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C55DD41280;
        Tue, 26 Jan 2021 12:13:45 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 26
 Jan 2021 12:13:45 +0300
Date:   Tue, 26 Jan 2021 12:13:44 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     David Disseldorp <ddiss@suse.de>
CC:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Message-ID: <YA/dSDH2NYSRi9Bi@SPB-NB-133.local>
References: <20210120102700.5514-1-d.bogdanov@yadro.com>
 <20210122234251.595d5b7a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234251.595d5b7a@suse.de>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 22, 2021 at 11:42:51PM +0100, David Disseldorp wrote:
> On Wed, 20 Jan 2021 13:27:00 +0300, Dmitry Bogdanov wrote:
> 
> > Now REPORT LUNS for software device servers always reports all luns
> > regardless of SELECT REPORT field.
> > Add handling of that field according to SPC-4:
> > * accept known values,
> > * reject unknown values.
> 
> We currently advertise SPC-3 VERSION compliance via standard INQUIRY
> data, so I think we should either support SPC-3 SELECT REPORT values or
> bump the VERSION field (SPC-4 behaviour is already scattered throughout
> LIO).
> Out of curiosity, do you know of any initiators which use this field?
> 

Hi David,

SELECT REPORT field can be used for vVOL (LU conglomerate) discovery and
for well-known lun listing.

The field is used by VMware ESXi:
https://support.purestorage.com/Solutions/VMware_Platform_Guide/User_Guides_for_VMware_Solutions/Virtual_Volumes_User_Guide/vVols_User_Guide%3A_Protocol_Endpoints

"PEs greatly extend the number of vVols that can be connected to an ESXi
cluster; each PE can have up to 16,383 vVols per host bound to it
simultaneously. Moreover, a new binding does not require a complete I/O
rescan. Instead, ESXi issues a REPORT_LUNS SCSI command with SELECT
REPORT to the PE to which the sub-lun is bound. The PE returns a list of
sub-lun IDs for the vVols bound to that host. In large clusters,
REPORT_LUNS is significantly faster than a full I/O rescan because it is
more precisely targeted."

The post also confirms that:
https://sourceforge.net/p/scst/mailman/message/33030432/

A few more targets that support SELECT REPORT field below.

Sun/Oracle tape library:
https://docs.oracle.com/en/storage/tape-storage/storagetek-sl150-modular-tape-library/slorm/report-luns-a0h.html#GUID-4140F40D-BD9A-495C-9A86-8BD7E91C985C

IBM Flash Storage:
https://www.ibm.com/support/pages/sites/default/files/support/ssg/ssgdocs.nsf/0/95d7115d7eb428e485257f80005cc3a7/%24FILE/FlashSystem_840_SCSI_Interface_Manual_1.2.pdf

With regards to bumping TCM to SPC-4, are there any objections if we
submit a separate patch for that? Or resubmit a series with the patch?

Thanks,
Roman
