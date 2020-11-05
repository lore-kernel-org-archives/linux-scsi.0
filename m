Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59E4C55178
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 18:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29F5A2087D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 18:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WFLu0cyH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbgKESah (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 13:30:37 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56473 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731799AbgKESah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 13:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604601033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=IYA+7XZd0FTvbt7376a9ukPP8jrFGDO7o2C4vH/z6kg=;
        b=WFLu0cyH45cfpeykMJ04BvSsW8ywn+8qHHHuldeycfSbFe45krIL+Z3RkJZtFVHLsEaQLk
        /JX3GXTwbXk5+c9CdrdelyxLq1chW25HUzZaIXKkAMVg8I9ADguD2kqk20UXvB+8Rksk1s
        y8iTs6KpOnzLWKzfXGzt5aJrG58ax3A=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2052.outbound.protection.outlook.com [104.47.5.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-9POQdmosMrGOZTzWwzwC9A-1; Thu, 05 Nov 2020 19:30:32 +0100
X-MC-Unique: 9POQdmosMrGOZTzWwzwC9A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CukxWFFT1WXP7LCpbnD38A8C0sOk1zTM3pdDlYa6ufbqP1zNeQ7GEyf1ns2DZU7d6iWnaYgU52YmeOCkil3AqL+a2bQZI5o2XoEgWus5PxM0/dh+5yyH+/pNL7Px2iyt//cENpnlt87Pet/uDRXn5hvmNCLFMjmI3bm6WpRqOHLvLm/6c0G2qa6gwY+xcmFMj2k59uNsSjjFoB/24VYE3OoFihuFNUKqlPne/ixK4bza2hsf5h1VqIrFhZqND/baWstQ5g/0zt01NX+HrboR0ydrm8rqzW26RzkP1b2WK3OddfIDb8SBQUHVLFpCtXfhZemG7/BuL5CZAvBJ7YbkBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzXuwhvkskKwfMc+ZCQpnKWxEmR/lViTgzkJFbRCV6Y=;
 b=ChveBf3YpO8UAHWzYzryJSLfw45wpMb5NlfhksGpDZHSHqQJhdCdKZzBGlGmf7M0dVaCWxF8a3rDUlwsXczQygPsAFUtXSRkDPe6RCqjZ16iyMMrD3sYQDxyqYG7yaJ9PGs7vbXiG54hHAQ5LTPW6Lcnz6jypqET9iYtLWWCREMVOkcqkXujPEKkhZOuVM1PxmnhyQcVYLUhx33uFHAWVBs7pKBlPm2TsPPj/1fcNz/a0v/UG2cT5gr2vDPSdqTsy7oBOjE3N5LXMCuhgFHoArevV8Xz7APyWgBRdYhRDxc27CY/7xtZPCMPnMFYbICK1SpWxciyEjIyoCqX9HACzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4518.eurprd04.prod.outlook.com (2603:10a6:20b:1f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 5 Nov
 2020 18:30:31 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 18:30:30 +0000
Subject: Re: [PATCH] scsi: libiscsi: fix NOP race condition
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
CC:     open-iscsi@googlegroups.com
References: <20200918210947.23800-1-leeman.duncan@gmail.com>
 <f0c9b3ff-7d93-9c2b-d405-e52fb4aa8c37@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Autocrypt: addr=lduncan@suse.com; keydata=
 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
 Xd8p+B+giaT8a1b5hWuz85V0
Message-ID: <c43612c1-14d7-4ccb-007f-23b9df1474cc@suse.com>
Date:   Thu, 5 Nov 2020 10:30:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <f0c9b3ff-7d93-9c2b-d405-e52fb4aa8c37@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Thu, 5 Nov 2020 18:30:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c22e11d-b189-473b-a393-08d881b8e008
X-MS-TrafficTypeDiagnostic: AM6PR04MB4518:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4518D12EBC8D09D601165A33DAEE0@AM6PR04MB4518.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+y9/OCVQ1HHA6nj57nBaiamYGKQNNsmKtjH9uFZk3wuvvu1zWBMDhCW/6IwYRSicujALPTDlmMk1qm3Pd7Rh569jb+Dw316PWoTx+BLmAjcXtE9llGBsKDFXvilzAV8PyswoJGbgJ1HMONPPvPwUX5Kql7uupZb7k3pcR4AOQNXCHTsVYIshECCcQUde7MpC5KvMYrLaghKpLbQRyqv2HCjFwb0eQScWxNmUPqGrrBXmkBftGig43mTRvhfuEqYYiYiEn6StCiy+Yl3LzPuTap0xLfqGE2zA6hyBEwjsz6klQ4+A/v46AK+PyEdAn+qaybTFTLfBcrrrAfS/itorL5uLDKdOJWkRap5+RVibYd+zXWRSkKYOULC88lqKu0m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39850400004)(396003)(346002)(376002)(136003)(53546011)(478600001)(5660300002)(52116002)(4326008)(6666004)(66476007)(8936002)(86362001)(2906002)(66946007)(66556008)(83380400001)(8676002)(16576012)(26005)(316002)(36756003)(31696002)(956004)(6486002)(186003)(2616005)(16526019)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ysF4AEbEEvbaosC3lzTrkTfDr0DBFIuu7C3bz4lyEtkYgHfGtJ3nK9vyTVnvIN8gK5mBfCULjP9ZKYsu4BaRwob5VaoL3BprskgCSIYiqwr1GZhfUZS8YYCRZj5JqzS9Tp87tKqNG0qjarSUv9aGig48GVfYgRpO3DfT2dZ1rIG7uDS7ZwInxF7/ZLhI26/VJPD7vnsepoyzqJqm9COB/WxnLMAKeZ/YyaBx6T45f0psbZyKIRjBc0avos//0J51iILwOVDtnWWUob2V6zNDVegBXIic4oUhotHvg43spU5j5qcefVlYpdhjCTOiamZJ4iy6L+zCV8VixhLxKR5tYtCNoE4h5Mn7secanB2hBeWy3uCusPg6NAmk1kOpcmzLss18aiNQz6pQn8Xsz13L7mCEyrqkxZA1SvRdUN5WLLDmgpFJX5X80/d5WfH+r9RQ2Zb9vtpG9h2KQ4YCOu3MyrFAoJRfE8qjEEU+GaPiYy1zsbZwZ0JaduSwzpk/7y7E/3yDtON9tCt8s/2ETHUnp48Dp4SEuDRcqClYXgHxJxAq/rT900hv9vi0hbuwb2E37IgeM7gnEvbjig4QzXLEWPuWYA4NbDgkvncYRNAsVQfLNXH/9t6dkMoQVl0+dfrvEeS5FlZdWe0DFZi9Y2GTLA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c22e11d-b189-473b-a393-08d881b8e008
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 18:30:30.7941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6nZvlMzZb0iT4SeNBMI0pDfBBU0xSo+LNp3bKEBP+aCwsA9NaVC956L7aoqLtmqBqjTOAOavDTNfBDH66tS1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4518
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/20 1:33 PM, Mike Christie wrote:
> On 9/18/20 4:09 PM, Lee Duncan wrote:
>> From: Lee Duncan <lduncan@suse.com>
>>
>> iSCSI NOPs are sometimes "lost", mistakenly sent to the
>> user-land iscsid daemon instead of handled in the kernel,
>> as they should be, resulting in a message from the daemon like:
>>
>>> iscsid: Got nop in, but kernel supports nop handling.
>>
>> This can occur because of the new forward- and back-locks,
>> and the fact that an iSCSI NOP response can occur before
>> processing of the NOP send is complete. This can result
>> in "conn->ping_task" being NULL in iscsi_nop_out_rsp(),
>> when the pointer is actually in the process of being set.
>>
>> To work around this, we add a new state to the "ping_task"
>> pointer. In addition to NULL (not assigned) and a pointer
>> (assigned), we add the state "being set", which is signaled
>> with an INVALID pointer (using "-1").
>>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>> =C2=A0 drivers/scsi/libiscsi.c | 11 ++++++++++-
>> =C2=A0 include/scsi/libiscsi.h |=C2=A0 3 +++
>> =C2=A0 2 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 1e9c3171fa9f..5eb064787ee2 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn,
>> struct iscsi_hdr *hdr,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 task->conn->session->age);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 if (unlikely(READ_ONCE(conn->ping_task) =3D=
=3D INVALID_SCSI_TASK))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(conn->ping_task, =
task);
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ihost->workq) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (iscsi_prep_mg=
mt_task(conn, task))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto free_task;
>> @@ -941,6 +944,11 @@ static int iscsi_send_nopout(struct iscsi_conn
>> *conn, struct iscsi_nopin *rhdr)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct iscsi_nopo=
ut hdr;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct iscsi_task *task;
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 if (!rhdr) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (READ_ONCE(conn->ping_tas=
k))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn -EINVAL;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(conn->ping_task, =
INVALID_SCSI_TASK);
>> +=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rhdr && conn->ping_task)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>> =C2=A0 @@ -957,11 +965,12 @@ static int iscsi_send_nopout(struct iscsi_c=
onn
>> *conn, struct iscsi_nopin *rhdr)
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 task =3D __iscsi_conn_send_pdu(con=
n, (struct iscsi_hdr *)&hdr,
>> NULL, 0);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!task) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rhdr)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRIT=
E_ONCE(conn->ping_task, NULL);
>=20
> I don't think you need this. If __iscsi_conn_send_pdu returns NULL, it
> will have done __iscsi_put_task and done this already.

Not an issue, as you already replied.

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iscsi_conn_printk=
(KERN_ERR, conn, "Could not send nopout\n");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (!rhdr) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* only track our=
 nops */
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conn->ping_task =3D task;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conn->last_ping =
=3D jiffies;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> Why in the send path do we always use the READ_ONCE/WRITE_ONCE, but in
> the completion path like in iscsi_complete_task we don't.
>=20

The answer is that I was only modifying the code that needed changing
for this bug. My first pass did not use READ_ONCE() or WRITE_ONCE(), but
Hannes suggested the change.

Now that I think about it more, the memory barrier stuff would make
sense only if all the access to that field are protected.

I will resubmit V2 of the patch.
--=20
Lee Duncan

