Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1CDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 10:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347555AbiFJKM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 06:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347523AbiFJKMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 06:12:25 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4152EEC30A
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 03:12:23 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 37A5E424DC;
        Fri, 10 Jun 2022 10:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received:received; s=mta-01; t=1654855941; x=
        1656670342; bh=6kmg8CZw3aJJuIkR5ofArRH2u89rx0rjRAJD4FMJW50=; b=o
        b3vzHQMdGZHu5QcEBw9ZYJ2AjklVkrHokblX/yNQnr54Xd1ZmpMVueDayHYvbUt4
        OJWwaKoRZLkReOGNaiBZtEV8DQ3YP06N4IdTstrVuRjJ1MsRQXN6/taMwL02irvx
        JIvqfWTQJGo/isOYZt1Amd8GKCAWBR6wH4IcUK8kEs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mCX-yjIITKsv; Fri, 10 Jun 2022 13:12:21 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B0E9142497;
        Fri, 10 Jun 2022 13:12:20 +0300 (MSK)
Received: from T-EXCH-07.corp.yadro.com (172.17.11.57) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 10 Jun 2022 13:12:20 +0300
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-07.corp.yadro.com (172.17.11.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Fri, 10 Jun 2022 13:12:20 +0300
Received: from T-EXCH-09.corp.yadro.com ([fe80::d9f:e165:8a50:d450]) by
 T-EXCH-09.corp.yadro.com ([fe80::d9f:e165:8a50:d450%4]) with mapi id
 15.02.0986.022; Fri, 10 Jun 2022 13:12:20 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>
CC:     open-iscsi <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        "linux@yadro.com" <linux@yadro.com>
Subject: RE: Antw: [EXT] Re: [PATCH] scsi: iscsi: prefer xmit of DataOut
 before new cmd
Thread-Topic: Antw: [EXT] Re: [PATCH] scsi: iscsi: prefer xmit of DataOut
 before new cmd
Thread-Index: AQHYenFLnkgrMqHdCEim3M4HDVs6OK1D5uuAgAAC6wCAAXQf4IAAFcyAgAFR6oCAAJqUgIAAmiMAgABeVFA=
Date:   Fri, 10 Jun 2022 10:12:19 +0000
Message-ID: <09cecc56ea2041dd8ccfafcba180f907@yadro.com>
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
 <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
 <6a58acb4-e29e-e8c7-d85c-fe474670dad7@oracle.com>
 <e5c2ab5b4de8428495efe85865980133@yadro.com>
 <48af6f5f-c3b6-ac65-836d-518153ab2dd5@oracle.com>
 <ffc1f4910d2b414c93dfa5d331436a53@yadro.com>
 <d3277470-9ef0-9a1a-974d-e80250bd35ac@oracle.com>
 <62A2E054020000A10004ACA8@gwsmtp.uni-regensburg.de>
In-Reply-To: <62A2E054020000A10004ACA8@gwsmtp.uni-regensburg.de>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.18.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgVWxyaWNoLA0KDQo+IEluIG15IHByaW1pdGl2ZSBwb2ludCBvZiB2aWV3IGlTQ1NJIGlzIGp1
c3QgImFub3RoZXIgdHlwZSBvZiBjYWJsZSIsIG1ha2luZyBtZSB3b25kZXI6DQo+IElzIGlTQ1NJ
IGFsbG93ZWQgdG8gcmVvcmRlciB0aGUgcmVxdWVzdHMgYXQgYWxsPyBTaG91bGRuJ3QgdGhlIGJs
b2NrIGxheWVyIG9yIGluaXRpYXRvciBkbw0KPiBzbywgb3IgdGhlIHRhcmdldCBkb2luZyBvdXQt
b2Ygb3JkZXIgcHJvY2Vzc2luZyAodGFnZ2VkIHF1ZXVlaW5nKT8NCg0KaVNDU0kgUkZDIGRvZXMg
bm90IHJlcXVpcmUgdG8gc2VyaWFsaXplIGEgY29tbWFuZHMgZmxvdy4gSXQncyBqdXN0IGFuICJp
U0NTSSB1c2VyIiBmZWF0dXJlIC0NCnRvIHNlbmQgc29tZSBzZXQgb2YgU0NTSSBjb21tYW5kcyBp
biBhbiB1bmJyZWFrYWJsZSBiYXRjaCB0byBhIGRldmljZS4NCkJ1dCwgYXMgZmFyIGFzIEkgdW5k
ZXJzdG9vZCwgdGhlIHByb2JsZW0sIE1pa2UgZGVzY3JpYmVkLCBpcyBub3QgYSByZW9yZGVyIGJ1
dCBhbiBpbmNyZWFzaW5nDQpvZiB0aW1lIGJldHdlZW4gZnVsbCBkYXRhIHRyYW5zbWlzc2lvbiBv
ZiB0aGUgY29tbWFuZHMgZnJvbSB0aGUgYmF0Y2guDQoNCj4gSSBtZWFuOiBJZiB0aGVyZSBpcyBh
IHByb2JsZW0gdGhhdCBvY2N1cnMgZXZlbiB3aXRob3V0IHVzaW5nIGlTQ1NJLCBzaG91bGQgaVND
U0kgdHJ5IHRvIGZpeCBpdD8NClNpbmNlIHRoYXQgaXMgc29mdHdhcmUgaVNDU0kgc3BlY2lmaWMg
aXNzdWUgaXQgY291bGQgYmUgZml4ZWQvaW1wcm92ZWQgaW4gc29mdHdhcmUuIEhvdyBpdCdzIGhh
bmRsZWQgaW4NCkhXIG9mZmxvYWRlZCBpbXBsZW1lbnRhdGlvbiBpcyB1bmtub3duIGZvciBtZS4N
Cg0KQlIsDQogRG1pdHJ5DQo=
