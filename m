Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFECEC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Oct 2022 17:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJLRLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 13:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJLRLW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 13:11:22 -0400
Received: from antispam1.zonit.com (antispam1.zonit.com [192.88.205.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973E7CD5FE
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 10:11:21 -0700 (PDT)
X-ASG-Debug-ID: 1665594679-18471ce6bd116c30001-ziuLRu
Received: from atlas.zonit.com ([199.88.250.66]) by antispam1.zonit.com with ESMTP id vtj6DkMrdEEekayH for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 11:11:19 -0600 (MDT)
X-Barracuda-Envelope-From: toms@zonit.com
X-Barracuda-Effective-Source-IP: UNKNOWN[199.88.250.66]
X-Barracuda-Apparent-Source-IP: 199.88.250.66
Received: from [172.30.2.121] (unknown [172.30.2.121])
        by atlas.zonit.com (Postfix) with ESMTP id 733F73A37EE
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2022 11:11:19 -0600 (MDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 atlas.zonit.com 733F73A37EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zonit.com; s=atlas;
        t=1665594679; bh=t5kGcNo1IFYW5Kfn6U6eqrFQglMQWW+CDWh/p9iq8is=;
        h=Date:From:Subject:To:From;
        b=l43F957mKUHNDg8lA49lkTUHuxB6pxAQzi+dfBINw8sNDjgun9vENO7K4b5G8ce4m
         PJF/zkhRGoiuIDM9ERYJG25xtdPvYkZvq1KmfUbDQB7p/7czDbzDjgHhHLeVyjqB7D
         HBwo6Iw1xy37vS5kDQVTxqPmXFhR9w6n0gjj6leU=
Message-ID: <2b61fe0c-b656-30a7-a5fb-e6cd5d08fde4@zonit.com>
Date:   Wed, 12 Oct 2022 11:11:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Tom Spettigue <toms@zonit.com>
Subject: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with EL
 8.6 driver?
To:     linux-scsi@vger.kernel.org
X-ASG-Orig-Subj: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with EL
 8.6 driver?
Content-Language: en-US
Autocrypt: addr=toms@zonit.com; keydata=
 xsBNBF89qnoBCADGzTB5IUOH/6fz5DIm4FTIMN6ATEYcTMMU65TAERjkFCC1EXxfRew9h9sp
 Ay6/4bwrg8atjmY6PRDZrF8nXs5wibZNwsORSO6ppqdNqEQT+mkl1tEc7mmShz1MRpHvCWJq
 2YyzdWG153dwr6ER1GH496EeroaDDi1pnFTAHp0gH4Lvo75zMkVfbf92CdMyIvw295YqS0XV
 fB2N025Wa38SBxoP4YqRpD1CuhYeIxlj0PJ844CSTdFVk48YkGd/kpW/L9E3Xl7WxrnXz6/2
 Q8YZbg99RX2j4IWDtVyArprtHilQfUe7w1kl+SFsR8FPeS9ayH2uEDF/lVJv7xaRJXWPABEB
 AAHNHlRvbSBTcGV0dGlndWUgPHRvbXNAem9uaXQuY29tPsLAlAQTAQgAPhYhBEvM5cdoINL1
 Q+Z45vg4tbRdeUsmBQJhICcTAhsDBQkFl7SYBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJ
 EPg4tbRdeUsmadsIAIoRGucz9ZAWt4U3SCR/ZeqpuGRQtz+/h+5Jj+B5t5Bx8uNarYUOy7va
 qKZjE2h3XRznwE6toHJksTCa9I7gwyfbH7I/Fp65A05OTA8HOaI6ZOvVq0MksRZox9w/7iV4
 BMupydzX6br/vNj+a2kgHWCykvos22eMfzeMohnsYMmKkCvo8KTIMjwOwknrWQdsTbZ3kR5h
 CN56kWfdjeM1Nr8GrOn72YQy5Ydchn2agJG3QXQJmBrBLnquaxuOEhC9iHPLjBMgdRrb5BIV
 WyorPd3fCyJW/68wqondZtL5Cuhl7ZDsV4FDSu7eBVjMstqtAUKOMuB8ny6KlCSGi2qyNgrO
 wE0EXz2qegEIAKugsXYAB3+GbcBSlfTvdUZMulO8t+zb/pKE6xhsRQof8JvcN4YCwhYe9Oal
 RiucQjBaf6wBld0sg+j5CpCbRnU3Ph54f4QEWme3gb0yJ23yxRHU3kwDg7LZvQbtbZ02GzcZ
 7TykolBkHV79sU+cxPXkjMtStni+ZdIwVRphlPQZ+DCPJK9f7x9fjF5CqpGeXCyv+SySNOkV
 3/i9NRP/ya1JovPw+hdwLj05D9+ktDfzNxJzYAFs4md73SnzjB7hMNU/SuuB9iXi9cZjx03T
 VITD4M7yMRkaPV1/LuZazNgDpuJcsbCOeurEMVOipm+ft4Hc3lPZrBEjNkOA0ToLAiMAEQEA
 AcLAhgQYAQgAJhYhBEvM5cdoINL1Q+Z45vg4tbRdeUsmBQJhICcTAhsMBQkFl7SYABQJEPg4
 tbRdeUsmCRD4OLW0XXlLJowGB/4/lEgxjDNYyz/E9n3jKW/ppNmrE+7DZjWf+HwIIwot1C9/
 tU8+3Npydeq9jSq8nV2ByPZhjet/+Iw6vO+iGZH6Mqw9XBqLh5YZ/MvGOEhFagNfwDyBohpc
 Amo0A7j4mzLSdYCCzS4ihPqfiLua2zk3t7yQ4UbGxt710WpffREHNwp1SkkNomKnSIfvCScp
 IWmHAZ9PiOlw+unK6vZIWBqR4JVYNRknxtCjLGkgdR4FPOI+UmKfxqyXx6+J6aSMtJnNotQq
 cFSJCMOu7hqCVIbzAtzq5pelSQ67vNTBMA20udYyKf2AcG3Xz1HV7vbwoCcNIpMUsuHA+lod
 4Pt6IX7N
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tkD7ybxi7osjoeC8eFizVbW6"
X-Barracuda-Connect: UNKNOWN[199.88.250.66]
X-Barracuda-Start-Time: 1665594679
X-Barracuda-URL: https://antispam1.zonit.com:443/cgi-mod/mark.cgi
X-ASG-Orig-Subj: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with EL
 8.6 driver?
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at zonit.com
X-Barracuda-Scan-Msg-Size: 1823
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.101371
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tkD7ybxi7osjoeC8eFizVbW6
Content-Type: multipart/mixed; boundary="------------T44DPARkTHNh7eQ49QjA0jt2";
 protected-headers="v1"
From: Tom Spettigue <toms@zonit.com>
To: linux-scsi@vger.kernel.org
Message-ID: <2b61fe0c-b656-30a7-a5fb-e6cd5d08fde4@zonit.com>
Subject: Errors with Sun StorageTek STK RAID INT (Adaptec ASR-5805) with EL
 8.6 driver?

--------------T44DPARkTHNh7eQ49QjA0jt2
Content-Type: multipart/mixed; boundary="------------oSPdMEYxewbrqDDHWbqLA16F"

--------------oSPdMEYxewbrqDDHWbqLA16F
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGV5IGFsbCAtDQoNCldlIGhhdmUgYW4gb2xkZXIgU3VuIE1pY3Jvc3lzdGVtcyBTdW5GaXJl
IHg0MjUwIHNlcnZlciB3aXRoIG9uZSBvZiBTdW4ncyANClNUSyBSQUlEIElOVCwgYSByZWJh
ZGdlZCBBZGFwdGVjIEFTUi01ODA1IChDb3VnYXIpIFJBSUQgSEJBIHRoYXQgdGFrZXMgDQp0
aGUgYWFjcmFpZCBkcml2ZXIsIGFuZCBJJ20gZ2V0dGluZyBhbGwga2luZHMgb2YgZXJyb3Jz
IHdpdGggaXQgaW4gQWxtYSANCkxpbnV4IDguNi4gSSBoYXZlIHBlcmZvcm1lZCBoYXJkd2Fy
ZSB0ZXN0cyBvZiBib3RoIHRoZSBzZXJ2ZXIncyBtZW1vcnkgDQooaXQgcGFzc2VkIGEgd2Vl
a2VuZCBvZiBtZW10ZXN0ODYrIHJ1bnMgb2YgMjQgcGFzc2VzKSBhcyB3ZWxsIGFzIGFsbCAx
NiANCm9mIG91ciBTdW4tYnJhbmRlZCBIR1NUIDkwMCBHQiAxMGsgUlBNIFNBUyBkcml2ZXMg
KHVzaW5nIFNlYWdhdGUncyANClNlYVRvb2xzIEJvb3RhYmxlLCBhbGwgMTYgcGFzc2VkIFMu
TS5BLlIuVC4gY2hlY2tzIGFzIHdlbGwgYXMgc2hvcnQgYW5kIA0KbG9uZyBkcml2ZSBzZWxm
LXRlc3RzKSwgYW5kIGFsbCBwYXNzIHdpdGggZmx5aW5nIGNvbG9ycyBhY3Jvc3MgbXVsdGlw
bGUgDQpydW5zIG9mIGV2ZXJ5IHRlc3QuDQoNCkkgbm9uZXRoZWxlc3MgYW0gZ2V0dGluZyBh
bGwga2luZHMgb2YgZXJyb3JzIG9uIG15IEFsbWEgTGludXggOC42IA0KaW5zdGFsbCB3aXRo
IHRoYXQgZGQtYWFjcmFpZC0xLjIuMS03LmVsOF82LmVscmVwby5pc28gZHJpdmVyIG9idGFp
bmVkIA0KZnJvbSBodHRwczovL2VscmVwby5vcmcvbGludXgvZHVkL2VsOC94ODZfNjQvLiBJ
IGRvbid0IGtub3cgaWYgdGhhdCdzIA0KdGhlIHdyb25nIGRyaXZlciBvciB3aGF0LCBidXQg
SSBnZXQgYmFzaWNhbGx5IG9uZSBzZXNzaW9uIG9mIHVzYWJsZSANCkxpbnV4LCBhbmQgb25j
ZSBJIHJlYm9vdCwgSSBnZXQgYWxsIGtpbmRzIG9mIGVycm9ycyAtIHNlZSBoZXJlOg0KDQpo
dHRwczovL2ltZ3VyLmNvbS9hL3F0MmFudzMNCg0KL2Rldi9zZGEgaXMgYSBzaW1wbGUsIHR3
by1kcml2ZSBSQUlELTEgYXJyYXkgLSBhbmQgSSBoYXZlIHRlc3RlZCBub3cgDQpmb3VyIGRp
ZmZlcmVudCBkcml2ZXMgaW4gdGhhdCBhcnJheSBpbiB2YXJ5aW5nIGNvbWJpbmF0aW9ucywg
YW5kIEkgZ2V0IA0KdGhlc2UgZXJyb3JzIGluIGFsbCBvZiB0aGVtLiBJIGV2ZW4gc3dhcHBl
ZCBvdXQgb3VyIFN1biBTVEsgUkFJRCBJTlQgDQooQ291Z2FyKSBSQUlEIEhCQSBmb3IgYW5v
dGhlciBvbmUgb2YgdGhlIHNhbWUgbWFrZS9tb2RlbCwgYW5kIGdvdCB0aGUgDQpzYW1lIGVy
cm9ycy4gTmVpdGhlciB0aGUgQWRhcHRlYyBSQUlEIEJJT1MgcmVwb3J0cyBhbnkgcHJvYmxl
bXMgd2l0aCB0aGUgDQphcnJheXMsIG5vciBkb2VzIFNlYVRvb2xzIC0gc28gSSdtIGluY3Jl
YXNpbmdseSBkaXNpbmNsaW5lZCB0byBiZWxpZXZlIA0KdGhhdCBhbnkgb2Ygb3VyIGRyaXZl
cyBhcmUgYmFkLCBJJ20gc3RhcnRpbmcgdG8gdGhpbmsgdGhpcyBpcyBzb21lIGtpbmQgDQpv
ZiBjb25maWd1cmF0aW9uIHByb2JsZW0sIG9yIHNvbWUga2luZCBvZiBkcml2ZXIgcHJvYmxl
bSB3aXRoIHRoZSANCmRkLWFhY3JhaWQtMS4yLjEtNy5lbDhfNi5lbHJlcG8uaXNvIGFhY3Jh
aWQgZHJpdmVyIHRoYXQgSSdtIHVzaW5nLiA6UA0KDQpBbnkgaWRlYXM/DQoNCi0tIA0KVG9t
IFNwZXR0aWd1ZQ0KU3RhZmYgRW5naW5lZXINCig3MjApIDQwNi01MjY5DQpab25pdCBTdHJ1
Y3R1cmVkIFNvbHV0aW9ucw0Kd3d3Lnpvbml0LmNvbQ0KDQo=
--------------oSPdMEYxewbrqDDHWbqLA16F
Content-Type: application/pgp-keys; name="OpenPGP_0xF838B5B45D794B26.asc"
Content-Disposition: attachment; filename="OpenPGP_0xF838B5B45D794B26.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBF89qnoBCADGzTB5IUOH/6fz5DIm4FTIMN6ATEYcTMMU65TAERjkFCC1EXxf
Rew9h9spAy6/4bwrg8atjmY6PRDZrF8nXs5wibZNwsORSO6ppqdNqEQT+mkl1tEc
7mmShz1MRpHvCWJq2YyzdWG153dwr6ER1GH496EeroaDDi1pnFTAHp0gH4Lvo75z
MkVfbf92CdMyIvw295YqS0XVfB2N025Wa38SBxoP4YqRpD1CuhYeIxlj0PJ844CS
TdFVk48YkGd/kpW/L9E3Xl7WxrnXz6/2Q8YZbg99RX2j4IWDtVyArprtHilQfUe7
w1kl+SFsR8FPeS9ayH2uEDF/lVJv7xaRJXWPABEBAAHNHlRvbSBTcGV0dGlndWUg
PHRvbXNAem9uaXQuY29tPsLAlAQTAQgAPhYhBEvM5cdoINL1Q+Z45vg4tbRdeUsm
BQJhICcTAhsDBQkFl7SYBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEPg4tbRd
eUsmadsIAIoRGucz9ZAWt4U3SCR/ZeqpuGRQtz+/h+5Jj+B5t5Bx8uNarYUOy7va
qKZjE2h3XRznwE6toHJksTCa9I7gwyfbH7I/Fp65A05OTA8HOaI6ZOvVq0MksRZo
x9w/7iV4BMupydzX6br/vNj+a2kgHWCykvos22eMfzeMohnsYMmKkCvo8KTIMjwO
wknrWQdsTbZ3kR5hCN56kWfdjeM1Nr8GrOn72YQy5Ydchn2agJG3QXQJmBrBLnqu
axuOEhC9iHPLjBMgdRrb5BIVWyorPd3fCyJW/68wqondZtL5Cuhl7ZDsV4FDSu7e
BVjMstqtAUKOMuB8ny6KlCSGi2qyNgrOwE0EXz2qegEIAKugsXYAB3+GbcBSlfTv
dUZMulO8t+zb/pKE6xhsRQof8JvcN4YCwhYe9OalRiucQjBaf6wBld0sg+j5CpCb
RnU3Ph54f4QEWme3gb0yJ23yxRHU3kwDg7LZvQbtbZ02GzcZ7TykolBkHV79sU+c
xPXkjMtStni+ZdIwVRphlPQZ+DCPJK9f7x9fjF5CqpGeXCyv+SySNOkV3/i9NRP/
ya1JovPw+hdwLj05D9+ktDfzNxJzYAFs4md73SnzjB7hMNU/SuuB9iXi9cZjx03T
VITD4M7yMRkaPV1/LuZazNgDpuJcsbCOeurEMVOipm+ft4Hc3lPZrBEjNkOA0ToL
AiMAEQEAAcLAhgQYAQgAJhYhBEvM5cdoINL1Q+Z45vg4tbRdeUsmBQJhICcTAhsM
BQkFl7SYABQJEPg4tbRdeUsmCRD4OLW0XXlLJowGB/4/lEgxjDNYyz/E9n3jKW/p
pNmrE+7DZjWf+HwIIwot1C9/tU8+3Npydeq9jSq8nV2ByPZhjet/+Iw6vO+iGZH6
Mqw9XBqLh5YZ/MvGOEhFagNfwDyBohpcAmo0A7j4mzLSdYCCzS4ihPqfiLua2zk3
t7yQ4UbGxt710WpffREHNwp1SkkNomKnSIfvCScpIWmHAZ9PiOlw+unK6vZIWBqR
4JVYNRknxtCjLGkgdR4FPOI+UmKfxqyXx6+J6aSMtJnNotQqcFSJCMOu7hqCVIbz
Atzq5pelSQ67vNTBMA20udYyKf2AcG3Xz1HV7vbwoCcNIpMUsuHA+lod4Pt6IX7N
=3D6IFn
-----END PGP PUBLIC KEY BLOCK-----


--------------oSPdMEYxewbrqDDHWbqLA16F--

--------------T44DPARkTHNh7eQ49QjA0jt2--

--------------tkD7ybxi7osjoeC8eFizVbW6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEES8zlx2gg0vVD5njm+Di1tF15SyYFAmNG9TcFAwAAAAAACgkQ+Di1tF15SyYW
/Qf/da97eJyocC7KX2zPMGV03HtYiN6F7EmIgdjOPOLJM9lApXN9GqTn1hAkSbp+gPO9ZqYc+zxm
3Lm8IU5CtJom69Cn9CZqcxJXhwBULxUd7CxELoUSAxV1iQQAdbkW2b+bfE6sODZ7dv8GjngTLmH6
y0fccLwS91rMKBCRzYuzYwEa6b3ISNTA6AatbpHz2E+0FzL2Wiw285FZ5oH0BarFpZaq9jFwoJ5Z
aPL37IDLKWV3k3Pl9s0Wf8v8LVM7Yez7K9jCFQhl5o+BuEVtdDrMBKN5R2XyMACdrqrMTSI8qJa9
YfbcS270tlKq66gdOg4jmgtjG7HHafqdezBlC6kT1A==
=t+zz
-----END PGP SIGNATURE-----

--------------tkD7ybxi7osjoeC8eFizVbW6--
