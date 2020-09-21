Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC49C4347E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 17:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22D4216C4
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 17:48:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gVdhNkZp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgIURsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 13:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728291AbgIURsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 13:48:41 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BBCC061755
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 10:48:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k133so4925929pgc.7
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 10:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=A5LvrOgw7JCinP1n3PZd7jklNuSpivAPqSjmiUpymk4=;
        b=gVdhNkZp7AzceLcwaiwSbnRJwcEoRcK7FVU/9l1FOyxw7FSrwL6s4U8tIrDvxXKuVZ
         QaLnqtsQ8eCktmEHS/wnBhyxoKGHO2yhYIRDcBQQJEVHt6wqTZMFH94SpVl3C6m5lUjD
         6IoWnEp/IkXmFQuv5GQMosk17xSqohsAH3928=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=A5LvrOgw7JCinP1n3PZd7jklNuSpivAPqSjmiUpymk4=;
        b=jhb2G6jcqKtBR6H4SdHnCtJYQWvVxxhlXiZ+u1mfdTIsd6ScnN2xg9Kg5NtAJwQlbr
         mHAbpQadyryVzmWAoDQ0pxYejJiTutcw+PGPBDyLo0zBl0ixOAI8KfDSRD++bWMW1r5c
         zV2JxrVVrW3qZxrXlWDPphxsRvgb5aHG4UvKSbnK9MGArOCY5rBfgVk0ejwnLoLGl6R+
         UJ6ZcoLIPFlnqGNhks5JZVDnMbUL9UnZ/tiGWIeg2uKtOAEn/JqKdGPGzv1H/aaiXAEP
         TwAVibW47Bw/BFBc9BIhldLEX4K5NhDwKZ6Byqh+vqi562Ni7FqosR0adAfBN79QKqye
         qhRA==
X-Gm-Message-State: AOAM530syptP2TvHk0R0JSqjz8KG5LC1nXiC+eGBGutZ30BvXsLpYV0v
        r1FZydUHzCuoPfYZdCl4aFkPNg==
X-Google-Smtp-Source: ABdhPJzIqhaKFio3YY6/bSeOJGsPoEXlsz87vNQNbVe5p9yJe2LETADpjUvkxjybA0hFX3FBbTm1Kw==
X-Received: by 2002:a17:902:6b05:b029:d0:a100:8365 with SMTP id o5-20020a1709026b05b02900d0a1008365mr1024988plk.11.1600710518550;
        Mon, 21 Sep 2020 10:48:38 -0700 (PDT)
Received: from [10.69.69.102] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gl17sm141107pjb.49.2020.09.21.10.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 10:48:37 -0700 (PDT)
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Shyam Sundar <ssundar@marvell.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>
References: <20200514101026.10040-1-njavali@marvell.com>
 <20200514101026.10040-3-njavali@marvell.com>
 <927c2cbd-682f-a80e-bd2e-2e5bd012ab2d@broadcom.com>
 <CA+ihqdiA7AN05k5MjPG=o8_pf=L-La6UigY4t0emKgJMXm=hnQ@mail.gmail.com>
 <BYAPR18MB2805AEA357302FCFA20D2B57B48F0@BYAPR18MB2805.namprd18.prod.outlook.com>
 <351333B3-F666-420F-A9D3-DB86D2617156@marvell.com>
 <7c33c4fb-d3ec-cd2e-4de3-ecb95ffec8b8@broadcom.com>
 <CAABD173-7FC1-4738-9299-CD91F96067DF@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <2afbb836-297c-1d16-b6ce-204d8737cf2c@broadcom.com>
Date:   Mon, 21 Sep 2020 10:48:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAABD173-7FC1-4738-9299-CD91F96067DF@marvell.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ded82c05afd675b4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ded82c05afd675b4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US

Shyam,

comments will be posted shortly

-- james


On 7/30/2020 9:10 AM, Shyam Sundar wrote:
> James,
>                                                                                  
> Please review the updated patchset to see if the changes make sense to you.
> There are a few deviations from what we discussed here.
>                                                                                  
> I have used a single structure definition to maintain all fpin statistics
> and we are maintain them at the granularity provided by the fabric instead of
> Using a single counter per category. The same
> structure is used across the fc_host_attr and the fc_rport structures.
>                                                                                  
> Given that the congestion signals will have to be maintained by the LLDs,
> as we do not have the plumbing to push those notifications to the transport,
> I have added them to the fc_host_statistics maintained and filled in by the
> LLD. All of the stats are displayed under the "statistics" folder under the
> sysfs.
>                                                                                  
> Under the host stats, a subset of stats (the Link Integrity FPINs) are
> redundunt, and are already maintained, read via the traditional mechanism.
> I have rolled them in nonetheless because during testing, they did not
> update to the same values (using the FPIN error injection commands). If we
> determine that these values will be in sync consistently, we can remove one
> of the subset at a later point.
>                                                                                  
> Regards
> Shyam
>
>> On Jun 25, 2020, at 4:25 PM, James Smart <james.smart@broadcom.com> wrote:
>>
>>
>>
>> On 6/11/2020 10:42 AM, Shyam Sundar wrote:
>>> Seems like this (and a previous email) never made it to the reflector, resending.
>>>
>>> The suggestions make sense to me, and I have made most of the recommended changes.
>>> I was looking for some guidance on placements of the sim stats structures.
>>>
>>>> On May 29, 2020, at 11:53 AM, Shyam Sundar <ssundar@marvell.com> wrote:
>>>>
>>>> James,
>>>>       I was thinking of adding a structures for tracking the target FPIN stats.
>>>>
>>>> struct fc_rport_statistics {
>>>> uint32_t link_failure_count;
>>>> uint32_t loss_of_sync_count;
>>>> ....
>>>> }
>>>>
>>>> under fc_rport:
>>>>
>>>> struct fc_rport {
>>>>
>>>> /* Private (Transport-managed) Attributes */
>>>> struct fc_rport_statistics;
>>>>
>>>>       For host FPIN stats (essentially the alarm & warning), was not sure if I should add them to the fc_host_statistics or
>>>> define a new structure under the Private Attributes section within the fc_host_attrs/fc_vport.
>> my initial thought was the same
>>
>>>>       In theory, given that the host stats could be updated both via signals and FPIN, one could argue that it would make sense
>>>> to maintain it with the current host statistics, but keeping it confined to transport will ensure we have a uniform way of handling
>>>> congestion and peer congestion events.
>> but then I have the same thoughts as well. And the commonization of the parsing and incrementing makes a lot more sense.
>>
>>>>      Would appreciate your thoughts there.
>>>>
>>>> Thanks
>>>> Shyam
>>>>     
>>
>> I would put them under the Dynamic attributes area in fc_host_attrs and fc_rport.
>> fc_host_attrs:
>> fpin_cn              incremented for each Congestion Notify FPIN
>> cn_sig_warn     incremented for each congestion warning signal
>> cn_sig_alarm    incremented for each congestion alarm signal
>> fpin_dn             incremented for each Delivery Notification FPIN where attached wwpn is local port
>> fpin_li                incremented for each Link Integrity FPIN where attached wwpn is local port
>>
>> fc_rport:
>> fpin_dn             incremented for each Delivery Notification FPIN where attached wwpn is the rport
>> fpin_li               incremented for each Link Integrity FPIN where attached wwpn is the rport
>> fpin_pcn           incremented for each Peer Congestion Notify FPIN where attached wwpn is the rport
>>
>> For the cn_sig_xxx values, the driver would just increment them.
>> For the fpin_xxx values - we'll augment the fc_host_fpin_rcv routine to parse the fpin and increment the fc_host or fc_rport counter.
>>
>> -- james


--000000000000ded82c05afd675b4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg6j4Wlig0NTfppdkT
QynBpYuJLYpzh2cAoVIFuD+BRbkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAwOTIxMTc0ODM4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEOWJlEv7XA1qW+i7pk7VwhUEa5yMl6OLTp6
rfsJh1rEPIpJSYKeIobpcsq2kEHZpERb7TqYTPQjgk+EMeohdVEpgxvvGXlIZWBDM+lzKFKx2VLS
o4J+VzC1u0AOuE51sBeU4Jf+boKbnK8n7ir5SwFPiecHE07ObTr1bzkQdAt/J7+8X9bvLmhqdRmg
L58uDE6HbPBs0hkUNq/lM0IQLKw/2emtsoYJc/St52Ii2WH8vmOOJo4gDGHCrGxsuN/81P0cVg81
lxM7K3wKYw9tAzSNdTrUKgx1ugfonCFoIHMdH47jYMO8VPjoGLjKehVnRG0zujorGm+7BKjt8mcx
cGo=
--000000000000ded82c05afd675b4--
