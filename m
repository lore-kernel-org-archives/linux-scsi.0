From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] split scsi passthrough fields out of struct request
 V2
Date: Fri, 27 Jan 2017 00:38:51 +0000
Message-ID: <1485477510.2540.27.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485455329.2540.7.camel@sandisk.com>
         <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
         <1485456745.2540.9.camel@sandisk.com>
         <db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
         <20170126185924.GA25289@lst.de>
         <ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
         <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
         <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
         <1485464486.2540.12.camel@sandisk.com>
         <6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
         <1485467235.2540.14.camel@sandisk.com>
         <e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
         <1485472465.2540.19.camel@sandisk.com>
         <e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
         <1485474426.2540.25.camel@sandisk.com>
         <b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0042.outbound.protection.outlook.com ([104.47.42.42]:43808
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752226AbdA0AjH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 19:39:07 -0500
In-Reply-To: <b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
Content-Language: en-US
Content-ID: <607CF041F0261740810834ADD695AEA2@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On Thu, 2017-01-26 at 16:50 -0700, Jens Axboe wrote:
> Clearly we are missing some requests. How do I setup dm similarly to
> you?
>=20
> Does it reproduce without Christoph's patchset?

Hello Jens,

I see similar behavior with the blk-mq-sched branch of
git://git.kernel.dk/linux-block.git (git commit ID 0efe27068ecf):
booting happens much slower than usual and I/O hangs if I run the
srp-test software.

Regarding creating a similar dm setup: I hope that in the future it
will become possible to run the srp-test software without any special
hardware and with in-tree drivers. Today running the srp-test software
with in-tree drivers namely requires IB hardware. This is how to run the
srp-test software today with in-tree drivers:
* Find a system with at least two InfiniBand ports.
* Make sure that the appropriate IB driver in the kernel is enabled and
  also that LIO (CONFIG_TARGET_CORE=3Dm and CONFIG_TCM_FILEIO=3Dm), ib_srp,
  ib_srpt and dm-mpath are built as kernel modules.
* If none of the IB ports are connected to an IB switch, connect the
  two ports to each other and configure and start the opensm software
  such that the port states change from "Initializing" to "Active".
* Check with "ibstat | grep State: Active" that at least one port is
  in the active state.
* Configure multipathd as explained in
  https://github.com/bvanassche/srp-test/blob/master/README.md.
* Restart multipathd to make sure it picks up /etc/multipath.conf.
* Clone https://github.com/bvanassche/srp-test and start it as follows:
  srp-test/run_tests -t 02-mq

Bart.=
