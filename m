Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DDEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE7520771
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Fp99ucXr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgGFMdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:14 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.4]:57224 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgGFMdN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594038789; i=@ts.fujitsu.com;
        bh=5P/tzgpiXbU1DXaEWQbTeSMFpDxg7TlK9Ly6pJZbOzk=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=Fp99ucXrV9bjot/rBb+4vRGaLA8uiwpbIDYTyCeSdOgrXSI9mLvHmOmna9rusbww7
         zrxOe2KBpCUOLoctoAdVhP/jmdHsLKt36rCxZuKG/ik32Hsj3G7nQbCLBSsjKWLULf
         ZS7r3s41iKn30Wh42p2Xvl5QHtdpvVH9rGif7VAQhCq/ChaWaxikRnplWRvihPr13M
         xMT6l8MbjHIipZ3YLj2kAOLmHL+ubic4VEWHJKGkAwRv8cG6tm8LdtFAa+AwLb47mo
         CfNu0ZVgP5EDbUht7iQo2zv8lunwGDqFAOLbSDP1WTUNM6HEPYXPM7rINpOS9DRQMp
         0gLK2LGQeeN0Q==
Received: from [100.112.194.55] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-west-1.aws.symcld.net id AD/A6-17694-40A130F5; Mon, 06 Jul 2020 12:33:08 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRWlGSWpSXmKPExsViZ8MxVZdFijn
  e4P05GYtpH34yW+xZNInJovv6DjaL5cf/MVn8nXSD1aJ16VsmBzaPy1e8PT4+vcXisfl0tcfn
  TXIBLFGsmXlJ+RUJrBmfN55gLvjBW/Hp2lmmBsbJ3F2MXBxCApMYJc4f3cUO4fQzSsx/1M/ax
  cjJISzgLHHpylZGEFtEwEhixumTLCBFzALrGCVuv1rOAtHxkEli0Y+pLCBVbAIGEism3QezeQ
  UcJR5+mgJmswioSOxc/pKpi5GDQ1QgXOLZCn+IEkGJkzOfgJVwCthJvGpeCLaYWcBMYt7mh8w
  QtrjErSfzmSBsbYllC18zT2Dkn4WkfRaSlllIWmYhaVnAyLKK0SKpKDM9oyQ3MTNH19DAQNfQ
  0EjX0BKIjcz0Eqt0E/VSS3XLU4tLdA31EsuL9Yorc5NzUvTyUks2MQKjIaXgQN0OxgevP+gdY
  pTkYFIS5d0kxBwvxJeUn1KZkVicEV9UmpNafIhRhoNDSYLXXwIoJ1iUmp5akZaZA4xMmLQEB4
  +SCK8bSJq3uCAxtzgzHSJ1ilGX4/aGJYuYhVjy8vNSpcR5PcSBigRAijJK8+BGwJLEJUZZKWF
  eRgYGBiGegtSi3MwSVPlXjOIcjErCvOYgq3gy80rgNr0COoIJ6IhGESaQI0oSEVJSDUyP5up9
  LT7ae3Rq0Ym0o/fndnA2inTF3nxcIN3SNLnygrLnYWOzDh1f18uzP52LtrctjN+5UMKzaY9pU
  5emzao/Kwuq4ptFVuYuYC5Psn14zzbr2kabuQEXGF8LzOcLVvBY8LdG6HJTml/PtUNxRyvm3z
  KQ+3F01hMmttCSIy7PCr5NONNddWbSU4H5zseYtPjfl6xkSImx2/Dq1Syph5uaQ1mkLTz+L9j
  F8F1cUTX6QreGYinr6+un5FKS+c1m65s4bQoQE1ezfJLu3ZYnLfcq20GcRzc4qKBb57k5Q1n3
  9Iyq5pXH1moX+noslp9rynTJzj2YKW6RTvdp95d3Hwc1vY8+v56zXCfkWYWDEktxRqKhFnNRc
  SIAUML9jI0DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-4.tower-267.messagelabs.com!1594038787!308851!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1834 invoked from network); 6 Jul 2020 12:33:08 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-4.tower-267.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 6 Jul 2020 12:33:08 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 066CWqle012075;
        Mon, 6 Jul 2020 13:32:59 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 6831B20057;
        Mon,  6 Jul 2020 14:32:44 +0200 (CEST)
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
To:     Michael Christie <michael.christie@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
 <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
 <2e70df6e-560f-590f-721c-2532f7af3d50@ts.fujitsu.com>
 <7642F0BE-2E98-47FA-B1B9-00CA083B6530@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <2dc8a518-01c8-fa28-dac5-3fe0162d2f62@ts.fujitsu.com>
Date:   Mon, 6 Jul 2020 14:32:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7642F0BE-2E98-47FA-B1B9-00CA083B6530@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020-07-03 23:19, Michael Christie wrote:

...

>> Why is the cfgfs_sess_supp flag per tpg? It seems to be set if either
>> tpg/sessions or any acl/sessions folder is created.
>> So what will happen here if e.g session for an acl is created while
>> only tpg/sessions exists?
>=20
> Ah yeah, that is bogus. I am still working on an issue in this code. I =
wasn=E2=80=99t expecting a line by line and just a general review of cfgf=
s vs sysfs :) Sorry about that.
>=20
> I originally made it so when we make the tpg and before it is enabled y=
ou had to do mkdir sessions on the tpg to signal the kernel that the app =
supports the new interface. The kernel would then make the acl sessions d=
ir for you.
>=20
> I was tracking down a bug in that though, and for the posting I made it=
 so userspace had to create the acl sessions dir. While cutting and pasti=
ng the code I forgot to fix up that code.

Ah, ok. Please see below.
>=20
>=20
>=20
>> Do we need an similar flag per acl also?
>> And if we have a per acl and the tpg flag I think they should be remov=
ed
>> when user removes an empty sessions folder.
>=20
> It=E2=80=99s just a lot easier to leave it set if userspace has enabled=
 it once. You actually need to take into account if the tpg is enabled, a=
nd then you have some issues with the drivers that have their own nexus i=
nterface, and then there are different userspace code paths that handle t=
his.
>=20
> I don=E2=80=99t think it=E2=80=99s going to be common to mix and match =
updated and non-updated tools, so once its set, it=E2=80=99s set. If you =
disagree let me know. It can be done.

I see no need for such a mix.

If it works like you described above - kernel creates acl/sessions dirs
after user created tpg/sessions - I think it is really fine.
