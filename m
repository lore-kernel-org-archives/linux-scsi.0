Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C2EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 14:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C2DC207C5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 14:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhA0Oq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 09:46:27 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:53594 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233297AbhA0Ops (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 09:45:48 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0F52641273;
        Wed, 27 Jan 2021 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1611758701; x=
        1613573102; bh=BGZGDUJnmXm3AFEaW8HlxTBMObccMxMIRwvHroqafvY=; b=M
        3VoAvFEmQzGGgVAxTbEmKTzw3aeFCmFztTl18r3Fbp9aZufdugrRXHg5ev0z9Ek2
        Q/NwX8X3PUKa2g1WPVDMc7K3BgFPPEtdz9xN5sMnqs4dB6eqCAABRPnvjrnXoPeq
        cI4I5fbesPR7Tsvo5weVq4pln/tVVXWYkejjnqBEQs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NJzq5HIOAOMN; Wed, 27 Jan 2021 17:45:01 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E1BA0411F8;
        Wed, 27 Jan 2021 17:45:01 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 27 Jan 2021 17:45:01 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Wed, 27 Jan 2021 17:45:01 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Thread-Topic: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Thread-Index: AQHW7xbhz/v++AJPt0KtRI7xihE05Ko670O0gACd+bA=
Date:   Wed, 27 Jan 2021 14:45:01 +0000
Message-ID: <83b96eded14d4722883836daebbe40dd@yadro.com>
References: <20210120102700.5514-1-d.bogdanov@yadro.com>
 <yq1tur3knh1.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1tur3knh1.fsf@ca-mkp.ca.oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

>> +	switch (sr) {
>> +	case SCSI_SELECT_WELLKNOWN:
>> +	case SCSI_SELECT_ADMINISTRATIVE:
>> +	case SCSI_SELECT_SUBSIDIARY:
>> +		/* report empty lun list */
>> +		goto out;

> I'm a bit concerned about things inadvertently breaking if we return an e=
mpty list for the well known LUNs.
According to SPC we shall report an empty list if there is no well-known LU=
NS.=20
FreeBSD has the same logic in REPORT LUNS handling. SCST does not support S=
ELECT_WELLKNOWN case at all.

I don't know the history of the existing behaviour to send always LUN0 inst=
ead of empty list. Probably it was=20
for the SCSI_SELECT_ALL_ACCESSIBLE(0x02) case, where SPC allows LUN0. My pa=
tch keeps it for the 0x00, 0x02, 0x11 cases.
Thus, I believe it does not break the backward compatibility.

BR,
 Dmitry
