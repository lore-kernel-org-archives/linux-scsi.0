Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7649EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 18:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377008AbiEDSg4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 14:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376986AbiEDSgp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 14:36:45 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 11:22:29 PDT
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B49965F1;
        Wed,  4 May 2022 11:22:29 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 233F742B44;
        Wed,  4 May 2022 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received:received; s=mta-01; t=1651687350; x=
        1653501751; bh=d1AvmeEuVZgsCOz9p7Jh6JALcdMQUebwCCJjiySqc3w=; b=Z
        Pl5px0nVEqVgiJ2jfO7OD1RiJNO8dvbS2wXDfzEg8Gqc9ieuLc0DTCYMPc9R/QJH
        bJwDE0x/J+/SywJAbD98WldPUm7LduUIZPhDVX2rslr0wr9aeV9lk7LXESt0IDu+
        TNkbb1g+914eUu86EuRKWaCE9JZ5+EwWBfFOQ5hS8c=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UoA5R8rV2ZWn; Wed,  4 May 2022 21:02:30 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0B4ED4283A;
        Wed,  4 May 2022 21:02:29 +0300 (MSK)
Received: from T-EXCH-10.corp.yadro.com (172.17.11.60) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 4 May 2022 21:02:29 +0300
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-10.corp.yadro.com (172.17.11.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 4 May 2022 21:02:28 +0300
Received: from T-EXCH-09.corp.yadro.com ([fe80::d9f:e165:8a50:d450]) by
 T-EXCH-09.corp.yadro.com ([fe80::d9f:e165:8a50:d450%4]) with mapi id
 15.02.0986.022; Wed, 4 May 2022 21:02:28 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: RE: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Thread-Topic: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Thread-Index: AQHXxLmS7SuA9HdbIk2r5RVxhcl+j6veWFEAgABFs0CBMY9zoA==
Date:   Wed, 4 May 2022 18:02:28 +0000
Message-ID: <bd9e50adcc95404c94b4408117a94b0a@yadro.com>
References: <20211019071843.14890-1-d.bogdanov@yadro.com>
 <ec9e01a3-73d0-a06b-8c20-ae492c0c3313@oracle.com>
 <15af5f6f490a42c5a02c9d9bd79f1a28@yadro.com>
In-Reply-To: <15af5f6f490a42c5a02c9d9bd79f1a28@yadro.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.178.114.42]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KSSd2ZSBqdXN0IHRyaWVkIG9uZSBtb3JlIHRpbWUgdG8gcmVwcm9kdWNlIHlv
dXIgZXJyb3IgYW5kIEkgZmFpbGVkIGFnYWluLg0KV2l0aCB5b3VyIGNvbmZpZyBmaWxlIHRoZSBi
ZWhhdmlvciBpcyB0aGUgYWJzb2x1dGVseSB0aGUgc2FtZSBmb3IgYm90aCBjYXNlcyB3aXRoIG15
IHBhdGNoc2V0IGFuZCB3aXRob3V0IG15IHBhdGNoc2V0OiANCiogZm9yIGR5bmFtaWMgQUNMcyAt
IHRhcmdldCBmYWlscyB0aGUgbG9naW4gYW5kIHNob3dzIHRoZSBiZWxsb3cgbG9ncy4NCiogZm9y
IHRoZSByZWdpc3RlcmVkIEFDTCAtIHRhcmdldCBzdWNjZWVkcyB0aGUgbG9naW4uDQoNCkNvdWxk
IHlvdSwgcGxlYXNlLCByZS1jaGVjayB0aGUgcGF0Y2hzZXQ/DQoNCkJSLA0KIERtaXRyeQ0KDQot
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRG1pdHJpeSBCb2dkYW5vdiA8ZC5ib2dk
YW5vdkB5YWRyby5jb20+IA0KU2VudDogRnJpZGF5LCBPY3RvYmVyIDIyLCAyMDIxIDEwOjQ4IEFN
DQpUbzogTWlrZSBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPjsgTWFydGlu
IFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47IHRhcmdldC1kZXZlbEB2Z2Vy
Lmtlcm5lbC5vcmcNCkNjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgbGludXhAeWFkcm8u
Y29tDQpTdWJqZWN0OiBSRTogW1BBVENIIHYzIDAvM10gdGFyZ2V0OiBpc2NzaTogY29udHJvbCBh
dXRoZW50aWNhdGlvbiBwZXIgQUNMDQoNCkhpIE1pa2UsDQoNCj4gSSBjYW4ndCBzZWVtIHRvIGdl
dCB0aGUgcGF0Y2hlcyB3b3JraW5nIHdpdGggdGhlIHRhcmdldGNsaSBjb25maWcgZmlsZSBiZWxv
dyBJdCB3b3JrZWQgb2sgYmVmb3JlIHRoZSBwYXRjaGVzLg0KPg0KPiBJIGdldCB0aGlzIGVycm9y
Og0KPg0KPiBPY3QgMjIgMDA6NTY6MjUgb2w0IGtlcm5lbDogQ0hBUCB1c2VyIG9yIHBhc3N3b3Jk
IG5vdCBzZXQgZm9yIEluaXRpYXRvciBBQ0wNCj4gT2N0IDIyIDAwOjU2OjI1IG9sNCBrZXJuZWw6
IFNlY3VyaXR5IG5lZ290aWF0aW9uIGZhaWxlZC4NCj4gT2N0IDIyIDAwOjU2OjI1IG9sNCBrZXJu
ZWw6IGlTQ1NJIExvZ2luIG5lZ290aWF0aW9uIGZhaWxlZC4NCg0KVGhpcyBraW5kIG9mIGVycm9y
IGlzIHJlcG9ydGVkIGZvciB0aGUgdW5rbm93biAoZHluYW1pYykgQUNMIHNpbmNlIHRoZSBjb25m
aWcgZmlsZSBoYXZlIG5vdCBoYXZlDQp1c2VyaWQvcGFzc3dvcmQgY29uZmlndXJlZCBmb3IgVFBH
LiBZb3VyIGNvbmZpZyBmaWxlIGxvb2tzIHN0cmFuZ2UgLSBpdCBoYXMgZ2VuZXJhdGVfZHluX2Fj
bHM9MQ0KYnV0IGhhcyBub3QgY3JlZGVudGlhbHMgZm9yIGR5bmFtaWMgYWNscy4NCg0KTG9naW4g
ZnJvbSB0aGUgY29uZmlndXJlZCBBQ0wgaW4gdGhpcyBjb25maWcgZmlsZSB3b3JrcyB3ZWxsIGZv
ciBtZS4NCg0KQ291bGQgeW91LCBwbGVhc2UsIGRlc2NyaWJlIG1vcmUgZGV0YWlscyBvZiB5b3Vy
IHVzZWNhc2U/DQoNCkJSLA0KIERtaXRyeQ0K
