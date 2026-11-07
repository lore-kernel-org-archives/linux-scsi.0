Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068212;
	b=JHMzMp9BFYQVX90q2Ky/55DNwJ1Jom75bWH3Jpkn8s7yQkWcyVr71mEc4CDEu15h6+KN
	 cjPwGDgASO7jGCxHkmWfHekAPLcfQdZNvz4JJ0fvnlScMWkQAsMnsCLP1iFLyh/ynFeYO
	 YorltYxqhpE0ei6Hfb8jfatVF06OgZdUBRsMPGFTs3jwBlvnmlT4WrSGYqlLyi0/KieWR
	 V5TNFmFet3agb464KHXoc8lb6IcEq2YMkSAa/Ok6FPixJHrXoRRBMCZrh7GNuriNlkJ/8
	 OqBC6YMHeGO1ACFW/g0/Zb2HdC/S0EGFy3XShI26BNCABJRY/krwQHlUOI1C7dSEc8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068212;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=PHKaxEtEKqXJj1LIGfyb8yoAsVA22m4oUNU2OaxDya4=;
	b=BKxMqMULzz9PFCtCxnwwIg3dE8V0qxDQ8YNcK5SyIGCDCfflTQzsZ4GeHoMC9JHjWwDe
	 dVbMo+OoksTDs4UTu89/d6uDupsOqng+tfLB0Z8sWTeIsNz/YZDWxIuEKjLuXuEieqRaK
	 PL1T5TViQbqm12nWFIlM1VvyIWPcE1FNiqen3dUR8dwGFOx4KrG/LviVXOBDJ2id8YV14
	 p9J6DRKDLA61Bs6mhZsq1Ckmvklea0+gOJjNu20x7EqyCcWifmosfhbVse6zPi1CaEFKf
	 rSU3GJNDRNUAbNgA9Y+58CAaanI5eEPO6J9gFxREEYM3Ja8aseOJW0crc9JtMXtpzTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ABA606D3C9;
	Sat,  7 Nov 2026 16:16:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21ABA606D3C9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABHWJnpTu9q752BAA--.3713S2;
	Sun, 08 Nov 2026 00:16:41 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Paul Ely <paul.ely@broadcom.com>
Cc: Justin Tee <justin.tee@broadcom.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 James Smart <james.smart@broadcom.com>,
 Martin K. Petersen <mkp@kernel.org>,
 Nigel Kirkland <nigel.kirkland@broadcom.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_release_rpi()
Date: Sat, 07 Nov 2026 15:17:28 +0000
Message-ID: <1794064648.2620604.vulab@iscas.ac.cn>
In-Reply-To:
 <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
References: <20260917144758.2157707-1-vulab@iscas.ac.cn>
 <CAEQnVQnWk2ADAvLEVCrgNE=dtf3D4DJ-UcosUQgGDj8=AMnA2A@mail.gmail.com>
 <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHWJnpTu9q752BAA--.3713S2
X-Coremail-Antispam: 1UD129KBjvJXoW7trW8tw15tr4xKF4fAw4ruFg_yoW8Kw1xp3
	ykKFnFyrs8t3Wxu3WxJa1Uta4S9F93GFW5Ary8KryDAFs0gF15JrWFqFs0gr9rGrnaq3y7
	Xa1Fgas8JF48Z3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAI
	w28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07bO_M
	-UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMEA2rvPcsZdAAAsD

Hi Paul,

Sorry for answering so late.  You asked me about the -EIO return a month
ago and I am only getting back to it now; that delay is on me.

You are right about it.  lpfc_release_rpi() cannot tell a negative errno
from a mailbox status, and the value was outside the MBX_* code space the
rest of the function returns.  lpfc_sli_issue_mbox_s4() now returns
MBXERR_ERROR for the non-polled command it cannot issue while interrupts
are disabled, which is also what lpfc_sli4_post_sync_mbox() returns when
it cannot post a command.

While going through the callers for that change I found one that does
depend on the sign: lpfc_bsg_issue_mbox() passes the raw result to bsg,
and bsg-lib only reports a negative result as an error, so a positive MBX
status reaches the ioctl caller as success.  That is already true for
MBX_NOT_FINISHED today; 2/3 fixes it so that 3/3 does not add another way
to hit it.

The series is:

  [PATCH v2 1/3] scsi: lpfc: Fix ndlp reference leak in lpfc_release_rpi()
  [PATCH v2 2/3] scsi: lpfc: Report bsg mailbox failures as an errno
  [PATCH v2 3/3] scsi: lpfc: Return MBX status when a non-polled mbox cannot be issued

1/3 is the patch you were testing.  The check itself is unchanged; it is
still `rc != MBX_SUCCESS && rc != MBX_BUSY`, the test
lpfc_config_port_post() and lpfc_issue_hb_mbox() already use for the same
purpose, and it covers both -EIO and MBXERR_ERROR.  I only rewrote the
comment above it.  3/3 is the change you asked for.  I kept 1/3 apart
because it is the leak fix I would like in stable; 2/3 and 3/3 are not
stable candidates.

One thing I saw and did not touch: NLP_UNREG_INP is set before the issue
and is not cleared when the command is not handed to the port, so a later
lpfc_release_rpi() for the same node returns early at the "1435
release_rpi SKIP UNREG" message.  That is pre-existing on the
MBX_NOT_FINISHED path too.  Clearing it would make a second unreg possible
for the same NPort, so I would rather ask than guess - tell me if you want
it in this series.

Testing: I have no lpfc adapter, so this is build tested only.  Mainline
at d48723711bae, drivers/scsi/lpfc/ builds with W=1 and no warnings.
checkpatch.pl --strict reports nothing on the three patches except
"unknown commit id" on the Fixes tag, which is an artifact of my shallow
checkout - 4430f7fd09ec is in mainline.  I could not run it on hardware,
and the changelogs say so.

Thanks,
Wentao

