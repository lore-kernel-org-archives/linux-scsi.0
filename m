Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842723D7FF
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793408; cv=none; b=Twh+u85k9crNWRA6lQ+iH01BZXsnoD6ZpMQqhssTWmAC0Y6NYQ9Gfd4L7N4l/7pSy9oDeJ5Z1PBT5eX1a+yBgVOLvkWZf/rMU4ThlQCsODC/JcN0TQDVvLQhnhETogF87OtlQv+4vm3bJ0R5mxCQy6pFBsNti9MG+hq3gr9YqwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793408; c=relaxed/simple;
	bh=5lIlqa7wUFqY8KmimjuPBrS1larhbSDeSSAVGss4eFY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZRAa9iS1c0YbpBWQvr1y0dXnZEjnb8oYJiogZdvWIjgyC54AaVZuAPX6V8TDzQ/2ArL4s3qwe0Ko7ovHRZoMeJ2DSD0X7an8yPhyEJsFc6Pq4Hc154PO+wyvfMZXXp/f2AqJxMDKK1QTE/54cKrU4aHXDdSx+kRfGEuqU4poO14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LblW5XAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LblW5XAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E54C1F00898;
	Wed, 30 Sep 2026 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793407;
	bh=KFl8Yd156fI3lChAfJqGUkLSdLohucHdi9Fk5slHCIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LblW5XAza5uZL6u053dHe1NQzcUo/iFC98rRDaO8G/Uz5Y4YuQ1KbMzvYnA9NPYH3
	 fVA1IC0Op1anYZL/lbwRfO0Zk5DsJpuWCZDGNhM9oz3RVRRDkR1ysSrT2WG6NoVbKL
	 hrA/30ZCxTUs8S4hbE0/MdZolNsbfKmuYBPq9pGAwzP1XO2e/v6uo3PGePEK/zVANl
	 4ivroGK2DpKET/fHT2vtPYEce7EOIV2gT7hVGBahz3WGQx6PVOkZ8E3tQdcvLwCI0N
	 pgWKK1SoeNwCxjlaCTjwijP3rkPhpYVbGoV29nv4USHWcvx0ayfvaZJoBtXmuTdtSS
	 Wbax46lK5LYyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 11/11] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260930-ibmvfc-fpin-support-v12-11-53a3fff7d77b@linux.ibm.com>
References: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
 <20260930-ibmvfc-fpin-support-v12-11-53a3fff7d77b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:36:46 +0000
Message-Id: <20260930183647.5E54C1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: unprocessed FPIN severity in extended FPIN events
- [Medium] scsi: ibmvfc: KUnit tests for extended FPIN silently lack assert=
ions and bypass core logic
--

commit ed8465cac668f337315cf039e8fff2bc929555e8
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

This commit implements support for extended FPIN messages received via the
asynchronous sub-queue. It adds conversion logic to populate complete
descriptor information and includes KUnit tests to exercise the extended
event handling.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3471,6 +3472,41 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_c=
rq *ibmvfc_fpin, u64 wwpn)
> +static struct fc_els_fpin *
> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
> +{
> +	u8 flags =3D ibmvfc_fpin->fpin_data.flags;
> +	__be32 threshold =3D cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
> +	__be16 modifier =3D 0;
> +	__be32 count =3D cpu_to_be32(1);
> +	__be16 type =3D 0;
> +
> +	if (flags & IBMVFC_FPIN_EVENT_TYPE_VALID)
> +		type =3D ibmvfc_fpin->fpin_data.event_type;
> +	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
> +		modifier =3D ibmvfc_fpin->fpin_data.event_type_modifier;
> +	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
> +		threshold =3D ibmvfc_fpin->fpin_data.event_threshold;
> +	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
> +		count =3D ibmvfc_fpin->fpin_data.event_data.event_count;
> +
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,

[Severity: Medium]
Does this code intentionally discard the event severity?

The extended FPIN payload can specify severity when the
IBMVFC_FPIN_SEVERITY_VALID flag is set, but that flag appears to be ignored
during this unpacking process.

Furthermore, looking at the existing ibmvfc_common_fpin_to_desc() function
that this calls, it hardcodes the generated severity:

static struct fc_els_fpin *
ibmvfc_common_fpin_to_desc(...)
{
...
        cdesc->severity =3D FPIN_CONGN_SEVERITY_WARNING;
...
}

Will this cause higher severity events sent by the VIOS to be permanently
downgraded and incorrectly reported to the FC transport layer?

[ ... ]
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
[ ... ]
> @@ -266,9 +267,147 @@ static void ibmvfc_full_fpin_test(struct kunit *tes=
t)
> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {				\
> +	struct ibmvfc_async_crq_event ae =3D { .type =3D IBMVFC_ASYNC_CRQ_SUB }=
;	\
> +	(crq).valid =3D 0x80;							\
> +	(crq).flags =3D IBMVFC_ASYNC_IS_FPIN_EXT;					\
> +	(crq).link_state =3D IBMVFC_AE_LS_LINK_UP;				\
> +	(crq).fpin_status =3D (fs);						\
> +	(crq).event =3D cpu_to_be16(IBMVFC_AE_FPIN);				\
> +	(crq).wwpn =3D cpu_to_be64(tgt->wwpn);					\
> +	(crq).fpin_data.flags =3D IBMVFC_FPIN_EVENT_TYPE_VALID;			\
> +	(crq).fpin_data.event_type =3D cpu_to_be16((ev));				\
> +	ae.subq =3D *(struct ibmvfc_async_sub_crq *)&(crq);			\
> +	pre =3D READ_ONCE(rport->fpin_stats.stat);				\
> +	spin_lock_irqsave(vhost->host->host_lock, flags);			\
> +	ibmvfc_handle_async(&ae, vhost);					\
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);			\
> +	flush_workqueue(vhost->fpin_workq);					\
> +	post =3D READ_ONCE(rport->fpin_stats.stat);				\
> +}

[Severity: Medium]
Are we missing the KUnit assertions in this macro?

The test records the pre and post statistics, but there are no checks
(such as KUNIT_EXPECT_GT(test, post, pre)) to verify the statistics actually
incremented.

Because this test uses a live global vhost via ibmvfc_get_first_vhost()
without mocking the IBMVFC_SUPPORT_FPIN_EXT capability, a test run on an
adapter lacking this capability will silently fall through to this bypass p=
ath
in ibmvfc_process_async_work():

    } else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
            dev_err_ratelimited(vhost->dev,
                                "Unexpected extended FPIN event received\n"=
);
    }

Since there are no assertions, does this mean the test still reports a pass
despite completely failing to process the events?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-ibmvfc-fpi=
n-support-v12-0-53a3fff7d77b@linux.ibm.com?part=3D11
