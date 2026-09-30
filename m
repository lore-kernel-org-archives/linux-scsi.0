Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BD51FCC2
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793573; cv=none; b=fVuxnClYAYuOaweloEmICKeXQ5lFZnkj6JDgk9suSCbBRSwN8pOqrCfAB4OVeOuH3SlVK360+40A09aGYWaSEi3UgsK5aPzkkR7K1pVvOzhhUETAObb0tCfq7qB+OG/20kqWoYvUpkucn1XtJvme+sVAp4mbOyUnlSwWKjDKYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793573; c=relaxed/simple;
	bh=c89pTlbLF++rXPt2y2OjhzIGeEGkSl+/6hgRaO8AItY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UQGcrlegmuZ9j+6O9cqGLB8eJ158uoR3JqOuFisxgUEJCua0UfLbej+vcvHmsBQ92yU+LQTgFmx74u9Ch0874og4O8GFEjSPVpir6oRLDrpVLTBjR1xOtfzuaOe9oeQEI9TNTMbPY8TSLAvTvwHHzgbSwmXH2/FxrZ45jO36jwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFeugfY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFeugfY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565D31F0089A;
	Wed, 30 Sep 2026 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793571;
	bh=fZIdBDH+inxtQS6Wb6baZoe5qUdpPu597Ffv8TCiSVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LFeugfY1rJ1XB6p5R0QyC4rT1g+trpkaDLoVIWqOal15xYDJRUFk+d5pJyHt0FYIB
	 Hwf4AiRA4Gx8AKFNpq3KUYT8shx4jwRPnd1B9e4qdAUXES9soiyDabY2SJDqU4DVu6
	 P0vj9+YvsMlxJADtE1RnivblkcEzFDbIIQcp6vDIzD6WNozMGySXXvz/cebfZ3pbsc
	 bIty8O/KmMFSUio5ISddD+UotpoHOeoYSYBnHCi5Lf8x05ACRTUX4pit7GOrkOE9H5
	 R6U7jsRRr0xJG3R5mgBbipUr2T5IfYiDNxOKUftinfo8VzOvD6ASDFYKWI+ws7f+jW
	 XQzpboV9K5YjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 04/11] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260930-ibmvfc-fpin-support-v12-4-53a3fff7d77b@linux.ibm.com>
References: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
 <20260930-ibmvfc-fpin-support-v12-4-53a3fff7d77b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:39:30 +0000
Message-Id: <20260930183931.565D31F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: unbalanced scsi_host_put() and UAF in kunit tests =
due to ignored scsi_host_get() result
--

commit 0f3f9d832e1029568dc3a6eb9097fdaa04016dcc
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

This commit implements support for a basic level of Fabric Performance
Impact Notifications (FPIN) in the ibmvfc driver. It adds an async
event handler for IBMVFC_AE_FPIN events that offloads FPIN processing
to a dedicated workqueue, and introduces KUnit tests for validation.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index cf775f0673a0f..e0fa9b547cbfe 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -7120,5 +7393,21 @@ static void __exit ibmvfc_module_exit(void)
>  	fc_release_transport(ibmvfc_transport_template);
>  }
> =20
> +#if IS_ENABLED(CONFIG_KUNIT)
> +VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void)
> +{
> +	struct ibmvfc_host *vhost =3D NULL;
> +
> +	spin_lock(&ibmvfc_driver_lock);
> +	if (!list_empty(&ibmvfc_head))
> +		vhost =3D list_first_entry(&ibmvfc_head, struct ibmvfc_host, queue);
> +	if (vhost)
> +		scsi_host_get(vhost->host);

[Severity: Medium]
Does this code need to check the return value of scsi_host_get()?=20

If it fails (for example, if the module is being concurrently unloaded and
the host state becomes SHOST_DEL before vhost is removed from ibmvfc_head),
this function will ignore the failure and return an unreferenced vhost
pointer to the caller.

> +	spin_unlock(&ibmvfc_driver_lock);
> +	return vhost;
> +}
> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_get_first_vhost);
> +#endif

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..7cc9d423d4a79
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{

[ ... ]

> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +	put_device(&rport->dev);
> +	scsi_host_put(vhost->host);

[Severity: Medium]
Could this unconditional scsi_host_put() cause a refcount underflow if the
earlier scsi_host_get() call failed?

The test might also perform a use-after-free by accessing members of the
unreferenced vhost if it was already freed concurrently by the unload path.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-ibmvfc-fpi=
n-support-v12-0-53a3fff7d77b@linux.ibm.com?part=3D4
