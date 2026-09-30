Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11731FFC48
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 08:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755783; cv=pass; b=Z1QcKY81U9lOiReuRNlEKBgMQkEfhXQQIb695u/TFWit3cyB3+3j3OvWvLYNOJDkPD1dTE7O1Wq/WhVNjbOU9sfrywur8LXvix3S0i6ab/bO76hX4HDhVR4UqSujul0a0Ap9eRWkYXsHD/+ukTBSHjQHtEyD7zjOnszzHqib+GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755783; c=relaxed/simple;
	bh=7v+Z2NvLyP1Hm/k1fy7IpFlOmf3pqbE17sA7MmzZcNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kVUvCSEDJHyzKYZrLIDUu+lEmnOHKtdSB9bJi/Ru5YSpKN0hAqHVdtN3ODg1ItmFds7kUaoJLqQAhZNIysabTcWAwQ/yKHRqk882+3hrWYPidpFxBOiRacxvizxGISL5iEfKca1PqhAkl9um3xPKqgeLWH5o1ukluOI81yryqOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=LtQBrOvK; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="LtQBrOvK"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-67109935888so4791596d50.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 01:09:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790755779; cv=none;
        d=google.com; s=arc-20260327;
        b=juJxVgSot063L7gR0PuiCXTzG2RhZspUBBK83Xa41J139IiiFxXZVyJ5I4A/VvwWqw
         RA+h/PjXvfLXDX6VUAi8zIbQxjmRpSVOmX7SRr/Qu7gAHIBsh+jWGS8nZk5MYkNuix75
         wT9P7WMUVMuUyqKtslH6SwVBSAwkdYo17usWaoJnIm9qJxpbLXoarO/W+V07LqPOafGe
         zoeXrK2ec+u1puTAOkcZNYuqiV4qZogTEoPNzJ/+4wEFZ4d+Em0QetsoBv7WC4Lc6h0P
         X0q7v8rB4+Pa+DNMFY4RI/sI9Tv3aTSyklOVWM0X0TINrWlnrVa8YH+8wVNNCgzTdPwR
         PrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEU+FVJCb2ns4rPbp1OSd4wmoWUl9OWrWDmUQ/07rgk=;
        fh=oyoH+s74zz+zRw7tZLSzLnc/Jr/SvZtWIWbt4gz6WLA=;
        b=idoUDoVuxOH9/XV3MXstaVNGs8FkqSo6QPGkms2otY4xY4wDMSq2plE7lJg3NGw/SI
         Dk5fXdbbovYJ2EPw1hyseQ+Ab3G5QgMOVoI7lUjt1txGNarXH5ndJPFI9EEJxy8lXNcm
         8qEiEZ9W6CvQFgUnJ5w3wDY2zWThO1CBW+xvvA6W8T48q59och3B/an1pomS1ScLowZ0
         l2NgKpMtX8hyP/7eAMkmY2Oz50zYmvmixBUE40tiDaOFJPtFOROrlMxRrkR5G9yOR6Oo
         +FOuqJ7M9mNWzidg5tZjIANKDtpriJ72gGdV1KvqtzVeqXawbr3Nut71xTO7U53I8QKS
         P8pQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1790755779; x=1791360579; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEU+FVJCb2ns4rPbp1OSd4wmoWUl9OWrWDmUQ/07rgk=;
        b=LtQBrOvKsVSv8QEhLgvJTuyTklglzY70pYL57eIbiwIBpo6wtlVsptMZhWDh7A3EAw
         bICU452TKc6jEOU0yJARsC2SQtthzvIGpcwyyQ2dEPnJQIRgurKe6JT6uxEKiczplT5C
         X+f2AfTFZi5YCoPLu3fAsEax8x8ydN66Qi9Dg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790755779; x=1791360579;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEU+FVJCb2ns4rPbp1OSd4wmoWUl9OWrWDmUQ/07rgk=;
        b=Y6g7mwUOPIsT8h5cqdvHEojC4dQwyuvfkj4CIl0d7AGQDA01ZROqsQvrAdfSAH/DLg
         U0GE1OdnMhJcb0lNr+pq6fYT5rOxxUgZjwb1ZkqhmeQrUK8XMPZeVNixrC6inJJ+RPA8
         0Lmm4zmjhPITZDwL9WPFNNP8+80KKNXCzA8K8odbhWy5qhgR4p0kfLeTcqciiRi895Hk
         RenlQioceSt6/UIFcToQY/EV5JZMZyxfNVXrtd+DjVwk3H4SeusozDMK5mFNHyi3Nv61
         UuX9FKKVJ68Z5hgP0FwusYAHAUGCBTtH/mmsLVFwj7AgJ2kqUJi2OFxZ2fd6fwu0JXSK
         CIjg==
X-Gm-Message-State: AFq9FYIWF8r5mWwUd4y6Xs66LeN+t9B67qHV/qLH77wVzK2pOOLlbBvl
	63dSKxNgNHCYVa6N52LWe6ONFkYbM+h3Rd1fEnXck/akNo13YtNyDkYZ45iZdxuiamy3sLWfPBJ
	LHhL0W7xDFWWUQ7SSvK3NBR7ABuWQt1U80c0e6D3C
X-Gm-Gg: AYBFou39mnvN7fsGkS/4FglKddGLEmZliDHqU1cMp059a23mPrPeCYszHLaqlpS4OVt
	Aw7oQ6X++mlV282+Q64yQodx936vf3vdgcaJJaWFd4BKe8t9N2tTGDisgdanIfr4cp8FyJE9jql
	V7yJearI8zhrh2RYGXCQGgWX8LXRicQqx4t2B19FMRy6b5EvawTWwmsujyGRA/oK/rR/nao+GhV
	lvfJqNEsXmS6wqWkWwO5otPrQ7F1awStR1/WVAALLxXNQo4qwUlc4kKOKo7eJaw0qGCytMq32hc
	qCTvlpLC0cVC3jnF+PsfY0svTEJRumTENRkznXicQuzUdkFs9fsdX7jHMwU5O4Mfp3O5ksrYesp
	4PCdXyrNOylF0C++xxd7uDUHwHbd8GLdZubC9Nr65ZXqC/9uOgQ19P7c1e5JIShh7ogFDMlADHF
	PvglGbTI0=
X-Received: by 2002:a53:bc0b:0:b0:676:24e2:c67e with SMTP id
 956f58d0204a3-6768351ba5fmr246243d50.89.1790755779399; Wed, 30 Sep 2026
 01:09:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAB4Wsm8AM3h19yLR26XQOtKX78ynQu-pC2H-gECvNtvJi58gwQ@mail.gmail.com>
 <7132c7c54ac5f6716f3e82d3666dbef015eae419.camel@redhat.com>
In-Reply-To: <7132c7c54ac5f6716f3e82d3666dbef015eae419.camel@redhat.com>
From: "Pluess, Tobias" <tpluess@ieee.org>
Date: Wed, 30 Sep 2026 10:09:28 +0200
X-Gm-Features: AclHuK_-iSto6yEc7QgENxwL_pKAAgaB3cSHOOD-isTBzrADWEgTW-Um0jjVtxs
Message-ID: <CAB4Wsm-HLX2haXvsq5CwnfpyxnzkCEnz__jGFh4_zr7RL78UZg@mail.gmail.com>
Subject: Re:
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Laurence,
sorry for my late reply.
Thanks for looking into this. I will setup my system accordingly to be
able to boot older versions. It will take a few days until I have time
but I will report ASAP my findings.

From inspecting my kernel update logs,

zgrep -E "status installed .*kernel-" /var/log/dpkg.log.*

I see that around that time when the error started occuring was when
updating from 6.14 to 6.17 and later. So I would guess the
corresponding changes must have happened around that point. I'm not
100% sure, but I will try booting the older kernels and will report my
findings.

Thanks!
greetings Tobias

On Sat, Sep 26, 2026 at 2:30=E2=80=AFPM Laurence Oberman <loberman@redhat.c=
om> wrote:
>
> On Fri, 2026-09-25 at 21:00 +0200, Pluess, Tobias wrote:
> > Hi,
> >
> > I am seeing a problem with the mpt3sas driver when using an
> > LSI/Broadcom SAS9207-8e connected to an external tape drive (HP
> > Ultrium 6650).
> > This setup worked without issues with older kernels. I cannot 100%
> > sure identify at which date the problem started to occur, but I would
> > say it started to occur around April or May this year.
> >
> > What happens:
> > a) the external tape drive is connected to the HBA using a SAS 8088
> > cable.
> > b) the tape drive is switched on and is detected normally and works
> > as
> > expected, backups can be made.
> > c) after the backup finishes, the tape is ejected and the drive is
> > idle, it is switched off.
> >
> > Here begins the interesting story. In the dmesg, I see the following
> > errors:
> >
> > [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: detecting: handle(0x0009),
> >                            sas_address(0x50014380353cba70), phy(3)
> > [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
> >                            retries(0)
> > [Fri Sep 25 20:02:40 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: detecting: handle(0x0009),
> >                            sas_address(0x50014380353cba70), phy(3)
> > [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
> >                            retries(0)
> > [Fri Sep 25 20:02:41 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > [Fri Sep 25 20:02:41 2026] START_UNIT: handle(0x0009), lun(0)
> > [Fri Sep 25 20:02:45 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: detecting: handle(0x0009),
> >                            sas_address(0x50014380353cba70), phy(3)
> > [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
> >                            retries(0)
> > [Fri Sep 25 20:02:46 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > [Fri Sep 25 20:02:46 2026] START_UNIT: handle(0x0009), lun(0)
> > [Fri Sep 25 20:02:49 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > [Fri Sep 25 20:02:52 2026] mpt2sas_cm6: log_info(0x31130000):
> > originator(PL), code(0x13), sub_code(0x0000)
> > [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: handle(0x0009),
> > ioc_status(0x0022) failure at
> > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify(
> > )!
> > [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: failure at
> > drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> > [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: handle(0x0009),
> > ioc_status(0x0022) failure at
> > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify(
> > )!
> > [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: failure at
> > drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> > [Fri Sep 25 20:02:55 2026] mpt2sas_cm6: handle(0x0009),
> > ioc_status(0x0022) failure at
> > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify(
> > )!
> >
> > Here, the last 2 lines are printed to dmesg approximately every
> > second, ad infinitum until the system is rebooted; the error never
> > stops. I am certain this did not occur with older versions of
> > mpt3sas,
> > but as I said, I cannot pinpoint exactly when the change happened.
> >
> > Powering up the tape drive again fixes the error, but as soon as the
> > tape drive is switched off again, the error reappears.
> >
> > However, the error doesn't occur every time the drive is switched
> > off.
> > Sometimes the mpt3sas driver seems to be happy and no errors are
> > reported. I think it has to do with some kind of timing, i.e. in
> > which
> > internal state the mpt3sas driver is when the external drive is
> > disconnected.
> >
> > Hardware:
> > * Serial Attached SCSI controller: Broadcom / LSI SAS2308 PCI-Express
> > Fusion-MPT SAS-2 (rev 05)
> > * external tape drive HP Ultrium 6650
> > * Linux pve0 7.0.14-12-pve #1 SMP PREEMPT_DYNAMIC PMX 7.0.14-12
> > (2026-08-11T11:05Z) x86_64 GNU/Linux
> > * mpt3sas
> >
> >
> > I wonder why this problem occurs and how it could be prevented. I
> > have
> > to say, my hot swap HDDs are connected to
> >
> > Serial Attached SCSI controller: Broadcom / LSI SAS3416 Fusion-MPT
> > Tri-Mode I/O Controller Chip (IOC) (rev 01)
> >
> > and here, I never have the issue, it only appears with the 9207-8e.
> >
> > I made my own "fix" to stop the driver from filling up my dmesg with
> > errors; using a little bash script with these commands
> >
> > echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/unbind
> > echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/bind
> >
> > resets the driver and it then stops printing errors. However I think
> > this is not a true solution to the problem, it just fixes the
> > symptom.
> >
> >
> > Any ideas how to proceed?
> > Unfortunately I don't quickly have another system handy where I could
> > test older versions of the driver.
> >
> > Thanks,
> > Greetings
> > Tobias
> >
>
> Hello
> Any chance you can boot an earlier set of kernels to try narrow down
> when this started. I don't have the older hardware to reproduce in our
> lab here. I will do some code inspection in the meantime to try figure
> out what triggers this and come up with some ideas.
>
> Would be good to know which version older kernel was not seeing this.
> Thanks
> Laurence
>
