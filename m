Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608A63AA4E1
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777029467; cv=none; b=OzhQm7Gj5MRAtk0/0/3vHmWGJjz8NWgHiPl8Jkfz1xk9r5nPgfeYz2FNaw5pLWLdK4PaFExPO2VRQq4aK+Zyy6gxsTYZ1PbSaBPDhI6nDu7J+9WjVvGSqrR4fZ1UX2dH43YJHscNnohBAEFWh/EeODeo24N58QPpqWe0eEiiCgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777029467; c=relaxed/simple;
	bh=UevUWfgvOw/6qkobewNsjZVdDmMdZr2JZzLCdcZ8U1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MvnogkWxIbuxCoDeWTzV0rGVsgVVqCt/Ydd+ianR0ldsYpIN5LgE03ggcmA1DPHzwHj+a8nkkI7wNNPJev7m6/mwIWbJ9cUUgkdZ86WvNgbOudW9/WOIW6R/jc+xBc2Cv8fW+QwAQa/pWvRdhEePBy+uaqYS7Wex4csh8RR4meY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Fv86tUuU; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Fv86tUuU"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-652fcd5a6d7so8414757d50.2
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 04:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777029462; x=1777634262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6Yh1AbSNKS5fSrCL1v8VTQjYE8MC/1RzzSDIp53F3M=;
        b=KUBElrc6AU3pSdazPDPXK5f0Qmh6Qj7r8gvKGwNOwczyLM0hNz2rkDPJtgfNm+pqj8
         JytNu67HZ5tYR33vEEDHwX3FGgADIwzzehnOTsT1htTdiTxqPyTDPNJvWrOodscFhSHe
         mzLCWkpNLAgZFnnbRxCqHFqBFBeQ1OTJg2d1aioHyI8phKq1ig43TnhOSItTLB0NouWi
         bWsnuYK0zuU3l1Hx9eVouuTYLNEZY+Z6eclUIwcn92bswG2ggkXAxDAp/xuDWzAfW7mZ
         D8hr6TbCqH27excCVH3FoGV/jvT0nUDneMmsRIiIgV7MGpn+C4SxQGEdk8tmSTGZt3ov
         CEMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8IhuwoWo96xEqo1CEbOVcS89ZyczAh76De6WjYBSmgHCoPpBxaz2T4/b9qJ3I7a0qB45lArkrjmy25@vger.kernel.org
X-Gm-Message-State: AOJu0YyCKTIMndoOq3uymXGZhBUvK5yHogSj5EawpEzX1zfe+90xR0ay
	fgMNjW43gKfFsAbAHHQmXax40TMFCUCYuXZon+6pJXD5dIOEUSRv7I9b1kzdS51RjlIVzQT1G3+
	ujQ5S8HaG7Ep974xeTlaNIYEmzyRwxMxEkv/XDDve4vwMGAQW7UzttjD2EpF+PZ50ZLMBFZJag+
	jqNMv9S4yYVXUnTEn9m/pIy33IWqMkEtqqZv1nW4rgsRZ+seYCD3lhEuVmpEox4TFknsBE8tb+R
	Kk+7rXJqI//MW7y
X-Gm-Gg: AeBDieuGdE+PB6PMn1o0iqf7nKppRRo9uTSoD3ydNKy3qc6LZ/I2qFnFK8/Gb3O4NLP
	feyUM8IH1bB4YMeFU9YCuGoeJPQaOuK6b0DiGauXz5GbfTogIJ4pkFYuOrQmSQwJufhxFVAK43/
	b2UiJW98O2lwsARjRJxDnt3BLWhtkis4LhwQ/8KNlsFU3Zqo+zp3XFPlU/hZipJQBEp+VISeLrh
	JYop++bCxmWWVNqUl/28lTo5VhPwgseObYsOjiVgmHGivA3nYeRFZkPVwghHgDQXF6DXJ4T0MrI
	FWVJjoumpkSDtwbFxvoLXIX6QPpnfzPFBMrLVWK3yd46bvPUhK9gXXsCfUBLClyH6nVzZZXcZPN
	lfgUYmFuOSPP9YQ/5QgnndEkVy2zM9Sl0kLgj14MsRP4N/lYzDHu2OUblAR/1LYQiB9MN0o9XJU
	z7XXXURwy3b2UXeXDTxaWAAAHMMvZGzhPTiR2rT685v9SSaBPknI7pVPJ3HuEdnqtE0xM=
X-Received: by 2002:a05:690e:4191:b0:650:f94:98dd with SMTP id 956f58d0204a3-65310b5c4e5mr27523634d50.59.1777029461793;
        Fri, 24 Apr 2026 04:17:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-17.dlp.protect.broadcom.com. [144.49.247.17])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-65314b72b17sm1692528d50.12.2026.04.24.04.17.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2026 04:17:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38e86a36956so52476171fa.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 04:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1777029460; x=1777634260; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s6Yh1AbSNKS5fSrCL1v8VTQjYE8MC/1RzzSDIp53F3M=;
        b=Fv86tUuUCkqT2jrldZIba70OXgDEHRRjMRgvLE2Ws63Taz/F/zn3VjkqJ9WsanWYJD
         6CTtTfD55P6m97XcK+i/jIB/KcbpzPpD6GBKmvRfKfdqgQKeoJVh5BkMGTYUwbg//cn1
         h6VxWubsrpCKVuaQCfup/V91VQj9IgjMhKMJc=
X-Forwarded-Encrypted: i=1; AFNElJ+3nmixShpF8IdsX1L5Wl9Bq6rqhhjrI64F+ExpbvxK7nO/ChwINS4e4XqtnO5jyN4CaaDYcn0t2HuF@vger.kernel.org
X-Received: by 2002:a05:6512:39c8:b0:5a2:b259:5569 with SMTP id 2adb3069b0e04-5a4172a2e01mr8949483e87.15.1777029459834;
        Fri, 24 Apr 2026 04:17:39 -0700 (PDT)
X-Received: by 2002:a05:6512:39c8:b0:5a2:b259:5569 with SMTP id
 2adb3069b0e04-5a4172a2e01mr8949478e87.15.1777029459250; Fri, 24 Apr 2026
 04:17:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
 <20260420113846.1401374-4-sumit.saxena@broadcom.com> <ab9e8e26-5522-4072-a2fe-07df5cb64441@oracle.com>
In-Reply-To: <ab9e8e26-5522-4072-a2fe-07df5cb64441@oracle.com>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Fri, 24 Apr 2026 16:47:39 +0530
X-Gm-Features: AQROBzD3rnS6K0Fzc-rSDLNDGLFFip-b_3tDPXyTB6tt1USTDylIQ_4Yy9FfiuM
Message-ID: <CAL2rwxrRW-0uf2RKdx7jhLkXy6+AB9WQCOOSVRTk0546BtLAPQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: use percpu counters for iorequest_cnt and iodone_cnt
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	Bart Van Assche <bvanassche@acm.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000bcbe9a065032e90b"

--000000000000bcbe9a065032e90b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 2:16=E2=80=AFPM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 20/04/2026 12:38, Sumit Saxena wrote:
> > iorequest_cnt and iodone_cnt are updated on every command dispatch and
> > completion, often from different CPUs on high queue depth workloads.
> > Using adjacent atomic_t fields caused cache line contention between the
> > submission and completion paths.
> >
> > Represent these statistics with struct percpu_counter so increments are
> > mostly local to each CPU, avoiding false sharing without growing
> > struct scsi_device further for cache-line padding.
> >
> > Suggested-by: Bart Van Assche <bvanassche@acm.org>
> > Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> > ---
> >   drivers/scsi/scsi_error.c  |  2 +-
> >   drivers/scsi/scsi_lib.c    |  8 ++++----
> >   drivers/scsi/scsi_scan.c   |  9 +++++++++
> >   drivers/scsi/scsi_sysfs.c  | 27 +++++++++++++++++++++++----
> >   include/scsi/scsi_device.h |  5 +++--
> >   5 files changed, 40 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 147127fb4db9..c7424ce92f3e 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -370,7 +370,7 @@ enum blk_eh_timer_return scsi_timeout(struct reques=
t *req)
> >        */
> >       if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
> >               return BLK_EH_DONE;
> > -     atomic_inc(&scmd->device->iodone_cnt);
> > +     percpu_counter_inc(&scmd->device->iodone_cnt);
> >       if (scsi_abort_command(scmd) !=3D SUCCESS) {
> >               set_host_byte(scmd, DID_TIME_OUT);
> >               scsi_eh_scmd_add(scmd);
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 6e8c7a42603e..0b05cb63f630 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1554,7 +1554,7 @@ static void scsi_complete(struct request *rq)
> >
> >       INIT_LIST_HEAD(&cmd->eh_entry);
> >
> > -     atomic_inc(&cmd->device->iodone_cnt);
> > +     percpu_counter_inc(&cmd->device->iodone_cnt);
> >       if (cmd->result)
> >               atomic_inc(&cmd->device->ioerr_cnt);
> >
> > @@ -1592,7 +1592,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(stru=
ct scsi_cmnd *cmd)
> >       struct Scsi_Host *host =3D cmd->device->host;
> >       int rtn =3D 0;
> >
> > -     atomic_inc(&cmd->device->iorequest_cnt);
> > +     percpu_counter_inc(&cmd->device->iorequest_cnt);
> >
> >       /* check if the device is still usable */
> >       if (unlikely(cmd->device->sdev_state =3D=3D SDEV_DEL)) {
> > @@ -1614,7 +1614,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(stru=
ct scsi_cmnd *cmd)
> >                */
> >               SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
> >                       "queuecommand : device blocked\n"));
> > -             atomic_dec(&cmd->device->iorequest_cnt);
> > +             percpu_counter_dec(&cmd->device->iorequest_cnt);
> >               return SCSI_MLQUEUE_DEVICE_BUSY;
> >       }
> >
> > @@ -1647,7 +1647,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(stru=
ct scsi_cmnd *cmd)
> >       trace_scsi_dispatch_cmd_start(cmd);
> >       rtn =3D host->hostt->queuecommand(host, cmd);
> >       if (rtn) {
> > -             atomic_dec(&cmd->device->iorequest_cnt);
> > +             percpu_counter_dec(&cmd->device->iorequest_cnt);
> >               trace_scsi_dispatch_cmd_error(cmd, rtn);
> >               if (rtn !=3D SCSI_MLQUEUE_DEVICE_BUSY &&
> >                   rtn !=3D SCSI_MLQUEUE_TARGET_BUSY)
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 9749a8dbe964..0b4fa89149af 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -351,6 +351,15 @@ static struct scsi_device *scsi_alloc_sdev(struct =
scsi_target *starget,
> >
> >       scsi_sysfs_device_initialize(sdev);
> >
> > +     ret =3D percpu_counter_init(&sdev->iorequest_cnt, 0, GFP_KERNEL);
> > +     if (ret)
> > +             goto out_device_destroy;
> > +     ret =3D percpu_counter_init(&sdev->iodone_cnt, 0, GFP_KERNEL);
> > +     if (ret) {
> > +             percpu_counter_destroy(&sdev->iorequest_cnt);
> > +             goto out_device_destroy;
> > +     }
>
> it could be neater to have:
>         if (percpu_counter_init(&sdev->iorequest_cnt, 0, GFP_KERNEL) ||
>             percpu_counter_init(&sdev->iodone_cnt, 0, GFP_KERNEL)) {
>                 err =3D some err;
>                 goto out_device_destroy;
>         }
>
Ack
> > +
> >       if (scsi_device_is_pseudo_dev(sdev))
> >               return sdev;
> >
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index dfc3559e7e04..1f5b2dc156a8 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -516,6 +516,10 @@ static void scsi_device_dev_release(struct device =
*dev)
> >       if (vpd_pgb7)
> >               kfree_rcu(vpd_pgb7, rcu);
> >       kfree(sdev->inquiry);
> > +     if (percpu_counter_initialized(&sdev->iodone_cnt))
> > +             percpu_counter_destroy(&sdev->iodone_cnt);
> > +     if (percpu_counter_initialized(&sdev->iorequest_cnt))
> > +             percpu_counter_destroy(&sdev->iorequest_cnt);
>
> Maybe I am wrong, but doesn't percpu_counter_destroy() handle the case
> of the percpu counter not being initialized? In other words, do we need
> the percpu_counter_initialized() checks?
percpu_counter_initialized() checks are not required; I will drop them.
>
> >       kfree(sdev);
> >
> >       if (parent)
> > @@ -936,11 +940,26 @@ static ssize_t
> >   show_iostat_counterbits(struct device *dev, struct device_attribute *=
attr,
> >                       char *buf)
> >   {
> > -     return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
> > +     /*
> > +      * iorequest_cnt and iodone_cnt are per-CPU sums (s64); ioerr_cnt=
 and
> > +      * iotmo_cnt remain atomic_t.  Report the widest counter for tool=
s.
> > +      */
> > +     return snprintf(buf, 20, "%zu\n", sizeof(s64) * 8);
> >   }
> >
> >   static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, N=
ULL);
> >
> > +#define show_sdev_iostat_percpu(field)                                =
       \
> > +static ssize_t                                                        =
       \
> > +show_iostat_##field(struct device *dev, struct device_attribute *attr,=
       \
> > +                 char *buf)                                          \
> > +{                                                                    \
> > +     struct scsi_device *sdev =3D to_scsi_device(dev);                =
 \
> > +     unsigned long long count =3D percpu_counter_sum(&sdev->field);   =
 \
> > +     return snprintf(buf, 20, "0x%llx\n", count);                    \
> > +}                                                                    \
> > +static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
> > +
> >   #define show_sdev_iostat(field)                                      =
       \
> >   static ssize_t                                                       =
       \
> >   show_iostat_##field(struct device *dev, struct device_attribute *attr=
,      \
> > @@ -950,10 +969,10 @@ show_iostat_##field(struct device *dev, struct de=
vice_attribute *attr,  \
> >       unsigned long long count =3D atomic_read(&sdev->field);          =
 \
> >       return snprintf(buf, 20, "0x%llx\n", count);                    \
> >   }                                                                   \
> > -static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
> > +static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
> >
> > -show_sdev_iostat(iorequest_cnt);
> > -show_sdev_iostat(iodone_cnt);
> > +show_sdev_iostat_percpu(iorequest_cnt);
> > +show_sdev_iostat_percpu(iodone_cnt);
> >   show_sdev_iostat(ioerr_cnt);
> >   show_sdev_iostat(iotmo_cnt);
> >
> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > index 9c2a7bbe5891..ad80b500ced9 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -8,6 +8,7 @@
> >   #include <linux/blk-mq.h>
> >   #include <scsi/scsi.h>
> >   #include <linux/atomic.h>
> > +#include <linux/percpu_counter.h>
> >   #include <linux/sbitmap.h>
> >
> >   struct bsg_device;
> > @@ -271,8 +272,8 @@ struct scsi_device {
> >       unsigned int max_device_blocked; /* what device_blocked counts do=
wn from  */
> >   #define SCSI_DEFAULT_DEVICE_BLOCKED 3
> >
> > -     atomic_t iorequest_cnt;
> > -     atomic_t iodone_cnt;
> > +     struct percpu_counter iorequest_cnt;
> > +     struct percpu_counter iodone_cnt;
> >       atomic_t ioerr_cnt;
> >       atomic_t iotmo_cnt;
> >
>
> Would it be simpler to make ioerr_cnt and iotmo_cnt also as
> percpu_counter? We could then drop some sysfs code for handling atomic_t
> counter.
It looks trivial, I will handle it in next revision.
>
> I noticed that there is a percpu_counter_init_many() - maybe we could
> use that, and index into the array of counters. Note that I am not
> fimilar with that API, so it may not be a good idea.
I need to check this. If it works well, I will handle it in the next versio=
n.

--000000000000bcbe9a065032e90b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ifscJ8gSasrjdgcsGC9lCyPXLwfNEU5C3Mbnua8OK6sTBpf6mvY88HW/6AoKiSpfo5jxCZQOm4Zz
oJWD5ea7ThJ2XdDk1rRtGUkwFgN9GRNfOoiIwkkA7EdEfV0eQkVqNgkqUyBSABXcduul2sd4/JQO
SsVmTdSKid7L6yZsqk5b3Xj+GMJwPdRfeKP2SRoys0SVnajc9Di+9Jy7uGKxxtb562egZauDFX/0
o0UgYfZrbwWfzJDYMLKzlrOD0M8yGkD8BnyIiVECAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQURSmmYGaiq6dg3CEvXQGHEXJF
8xwwDQYJKoZIhvcNAQELBQADggIBAAl0pcCjujKdwmgtiGl2naEY5wB4G601Kuu3032tR7wmgZLg
k+lg9fhAA0boPsi1FE1Pwb93YDBGr/naS/oQ9JglSMeEVzeRvCqjFS4FpouBAFHB77c8w3ZwJ3+t
FSRJW9SbW0DADBn5t8GAjv2aSm5vDorqFe9MKOYEe50yYDQEUAsEt5QkrLTcEx9ntvVb25MxI8vM
bdfqna+/TyCmFmnGAz58jiw5DxLn++6wMmAk0SeUEuMrAlRIyhte6BBSBQ5cL1P+DWSqQbm/pwCq
NhySSLNtTi2dKJvvg6Ax9au913KiJj6uZfPlh6/0kaVKM5GhIABUcm3c6g2qD7ITJxB/p1kjYKLa
hVrtrjK7000lHKTPFr6MWB4Ggx7yKQ9yIlPMKKF/Lj8FabYCqeM5ovG7kaK8FYXug5vjNjN0nedR
X3P8o+8aL6WFIAAAKm2DqZh3252Gcken8v5c+f0SXWSJFvemfFNgrJiQFnFVrOE5v7qwvM/KvVCA
dYm4Ph9QYI0sm+Xitx8MkdOJtq5mcPWowGi8UiCgkOidv4ki1SA0wptfquUhbfS9b2M3XUHCEIUX
4ECvIjR3f+E0NbBIfPccWfYUaDLvo2qhLYS3KQbhKdXcJ83ha17mbVNZbDDo9upNcLO/oPyDbCNF
J6UpXZmis1wnCynhK4kQfwFhW7H+MYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCAsJVIs
imt5i/563g3AtvT5NVYWiKB4vhOrddc8pye+6jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA0MjQxMTE3NDBaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCcAGsT8Vc9oNjeMyzZ/hlFK0KFTWLf1Rl7oeXwaIe4
LQvqFtNrIhT8rJV3+2SCOhE0xDYzeI8MtpOdizcDdvOYqtxGO6lz9tTyHBoAfXfzF5l1zH41Nl1U
Scymdvx26VozTZt7lTtRTiOi/eWScFaFibIjnc0KC+NQ5AVzw8wodWPkC3OI9rUhm5Xe7Jhr2TJi
UWa3ABkJXTxEnQfdkz3XGb+nLEn2dRnVAEK6iTPORiiiywNXEIrVD6pGJUOLwOXQZ0OGgzsleC5K
xjWsPfnI1kPk+5mS4uT9FxxX235zTuHuzni3JgDvuu8PHWMe2Mf/9nvU/E7spQDgji36GrAn
--000000000000bcbe9a065032e90b--
