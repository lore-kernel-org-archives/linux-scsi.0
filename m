Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AABC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 14:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C4B64E4D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 14:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBWOHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 09:07:05 -0500
Received: from c.mx.filmlight.ltd.uk ([54.76.112.217]:48030 "EHLO
        c.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhBWOHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 09:07:03 -0500
X-Greylist: delayed 85339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2021 09:07:02 EST
Received: from localhost (localhost [127.0.0.1])
        by omni.filmlight.ltd.uk (Postfix) with ESMTP id D6B7540000F1;
        Tue, 23 Feb 2021 14:06:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 omni.filmlight.ltd.uk D6B7540000F1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=filmlight.ltd.uk;
        s=default; t=1614089179;
        bh=tuHxiZa1Vyq8+DwuItYy9oAF6+QELLJtklOXef1sGkw=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=s+zZYfswguDB91uHLhTqU/Uo4lpOXzFFkf2bjgXBOJd3DpEhYteyrc6otRNkeGO7J
         D4OwMK6LB4kpEIC3T2ZLIDJ5gue5cMjQtUXhYMiZ6+9X72wzrbELJGmXcH8prr9ZIf
         r5MbDSmjEmVzRyRBFz4GSoYrAo/B4NTxQ3Q9/JLU=
Received: from [192.168.0.78] (cpc122860-stev8-2-0-cust234.9-2.cable.virginm.net [81.111.212.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: roger)
        by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id 603AC888156;
        Tue, 23 Feb 2021 14:06:19 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
From:   Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4bff6232-6abd-dae8-c240-07a1a40178bf@huawei.com>
Date:   Tue, 23 Feb 2021 14:06:18 +0000
Cc:     Roger Willcocks <roger@filmlight.ltd.uk>, Don.Brace@microchip.com,
        mwilck@suse.com, buczek@molgen.mpg.de, martin.petersen@oracle.com,
        ming.lei@redhat.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, hare@suse.de,
        Kevin.Barnett@microchip.com, pmenzel@molgen.mpg.de, hare@suse.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BF6685B6-B23F-49BC-B905-6ABE6FD3F44D@filmlight.ltd.uk>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <SN6PR11MB28482D89B75197B742459063E1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
 <0DB85ADC-B962-4AF9-B106-3F3B412CE4DB@filmlight.ltd.uk>
 <4bff6232-6abd-dae8-c240-07a1a40178bf@huawei.com>
To:     John Garry <john.garry@huawei.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 23 Feb 2021, at 08:57, John Garry <john.garry@huawei.com> wrote:
>=20
> On 22/02/2021 14:23, Roger Willcocks wrote:
>> FYI we have exactly this issue on a machine here running CentOS 8.3 =
(kernel 4.18.0-240.1.1) (so presumably this happens in RHEL 8 too.)
>> Controller is MSCC / Adaptec 3154-8i16e driving 60 x 12TB HGST drives =
configured as five x twelve-drive raid-6, software striped using md, and =
formatted with xfs.
>> Test software writes to the array using multiple threads in parallel.
>> The smartpqi driver would report controller offline within ten =
minutes or so, with status code 0x6100c
>> Changed the driver to set 'nr_hw_queues =3D 1=E2=80=99 and then =
tested by filling the array with random files (which took a couple of =
days), which completed fine, so it looks like that one-line change fixes =
it.
>=20
> That just makes the driver single-queue.
>=20

All I can say is it fixes the problem. Write performance is two or three =
percent faster than CentOS 6.5 on the same hardware.


> As such, since the driver uses blk_mq_unique_tag_to_hwq(), only hw =
queue #0 will ever be used in the driver.
>=20
> And then, since the driver still spreads MSI-X interrupt vectors over =
all CPUs [from pci_alloc_vectors(PCI_IRQ_AFFINITY)], if CPUs associated =
with HW queue #0 are offlined (probably just cpu0), there is no CPUs =
available to service queue #0 interrupt. That's what I think would =
happen, from a quick glance at the code.
>=20

Surely that would be an issue even if it used multiple queues (one of =
which would be queue #0) ?

>=20
>> Would, of course, be helpful if this was back-ported.
>> =E2=80=94
>> Roger


