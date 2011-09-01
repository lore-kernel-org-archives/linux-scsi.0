From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 01 Sep 2011 18:18:24 +0200
Message-ID: <1314893904.2823.30.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110901160724.GN9189@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59620 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab1IAQSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2011 12:18:30 -0400
In-Reply-To: <20110901160724.GN9189@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

Le jeudi 01 septembre 2011 =C3=A0 11:07 -0500, scameron@beardog.cce.hp.=
com a
=C3=A9crit :
> On Thu, Sep 01, 2011 at 05:24:02PM +0200, Eric Dumazet wrote:
> > Stephen,
> >=20
> > Current linux-3.1-rc4+ is a total disaster on my BL460c G6
>=20
> What kernel were you running successfully previously?
>=20
> I saw similar on BL460cG7 on Friday with 3.1-rc4,
> but I'm not sure the problem is in the driver. =20
> I installed rhel6.1, then put 3.1-rc4 on.  Turning off
> "Virtualization" in the kernel config seemed to help
> (allowed it to boot) and so I thought that must have
> been the source of the issue.  So, you might try that.
>=20
> However, I rebooted that machine just now, and
> now I am getting the similar "hpsa 0000:0c:00.0: resetting device 0:0=
:0:0"
> message, so that's pretty weird.
>=20
> The cmd_alloc failure, I didn't see, but I may have missed it
> (didn't have console directed to serial output.)
>=20
> cmd_alloc failing is not generally expected, as we reserve enough
> commands that the upper layers should never exhaust them all (should
> honor hpsa's max request limit), so that's pretty weird that
> you're seeing that.
>=20
> I am able to run 3.1-rc3 on rhel6 just fine on other systems (DL380g7=
,
> for example) and I don't think there are any hpsa changes between rc3
> and rc4.  (haven't tried rc4 on the dl380g7 yet).
>=20
> So, I'm not sure what's going on with the BL460c yet, but I am
> aware of the problem and have already seen it.  I can't think of
> any driver changes lately which should be causing such
> changes in behavior.
>=20
> -- steve

Here is my current bisection log

git bisect start
# bad: [9e79e3e9dd9672b37ac9412e9a926714306551fe] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
git bisect bad 9e79e3e9dd9672b37ac9412e9a926714306551fe
# good: [322a8b034003c0d46d39af85bf24fee27b902f48] Linux 3.1-rc1
git bisect good 322a8b034003c0d46d39af85bf24fee27b902f48
# bad: [0c3bef612881ee6216a36952ffaabfc35b83545c] Merge branch
'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
git bisect bad 0c3bef612881ee6216a36952ffaabfc35b83545c
# good: [8c70aac04e01a08b7eca204312946206d1c1baac] Merge branch
'staging-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect good 8c70aac04e01a08b7eca204312946206d1c1baac

I'll let you know if I can bisect before destroying (again) my distro

(I re-installed a fresh debian wheezy/sid)



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
