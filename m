Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A754541378A;
	Fri, 24 Jul 2026 22:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930529; cv=none; b=Ppv+6tKN8UbLf0VYFbTmzo2qDtcrBG8Qa6uoGz+5x/lLq/Bl8Ko6dR7XXpeblaQ5hT5aqgcPYtGg797N4UJgGqwn/NQI62DY8Op5zVVp+MBBS2uuSKNFSBegHqviAmBgikspOmFa+kajrBRD5K7zciowTXlfmRnfTkI2J/IagSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930529; c=relaxed/simple;
	bh=/LclVUTKBPKGvm71CcH0DqvBg20UruN2flob+j147qc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nZPtXiw3zXmmnIv2FMjsBO0g44kpJ+zh+BCk3oEQTrSdjazfuW41PM2jBeW6np3590NMCL53hFyiVq/OcRiFxAHMui8xeOHz1CTeWiiFV/PbAN49fpoixWFpbQgaDykYADCDkVZoFiDXfSbfsIigpfJW6f3uEf5DKQz026PEmpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SW1jA5Cn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SW1jA5Cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C05D1F00A3A;
	Fri, 24 Jul 2026 22:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930528;
	bh=butDrgyw+h/lIiHxHmoL8ZxppbWZX3+rlT+nnGvSiMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SW1jA5CnzzM8AHMJBEWjm28GEHl2IrbVpfyBsLGEPMSvCms1A4cNMTdkSb4ApBGcl
	 o3b7VLVdWgVaoXeMbXM3ZCGmukwnwKdTZjZWuW5Le7mGRJLCnS6GBLrRhjwI+i9Poa
	 RP/3y5F2cFSW2vDOUxuBq3a7z2LhVgkKo9sw03PDik9mYIWBLFg+vRFnj0NMuZ0SW7
	 v9HBmpXwsZgxFX+jvyu0TJePHccKl/d1tw0JSXrt7f7F5Bg34DBXzRCPSx3qjkjP4J
	 DrImmoBqJKriKA53LH4dKBv3HdsX4UoEytSLmOg+cnClz+rXiZlYKqN4wLFwrU0ANK
	 p7kmv2V7NpNzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/9] PCI: Fix dyn_id add TOCTOU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: cassel@kernel.org, linux-pci@vger.kernel.org, dlemoal@kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-8-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-8-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:07 +0000
Message-Id: <20260724220208.2C05D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] `pci_match_device()` returns a pointer to the `id` field of a dyna=
mically allocated `struct pci_dynid` after releasing the `drv->dynids.lock`=
 spinlock, which can result in a Use-After-Free in the probe path if the ID=
 is concurrently removed via sysfs.
--

--- Patch [8]: [PATCH v4 8/9] PCI: Fix dyn_id add TOCTOU ---
commit b2b9cd8b65d097234cb7fc1e84df45480eb112de
Author: Gary Guo <gary@garyguo.net>

PCI: Fix dyn_id add TOCTOU

Currently there is a TOCTOU issue in new_id_store() as the dyn ID insertion
in pci_add_dynid() and the pci_match_device() are in separate critical
sections.

Fix this by moving the existing ID check to inside pci_add_dynid() and only
check against the static ID table outside the critical section.

> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index c9424edb45481..ab3bb756ce89a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
[ ... ]
> @@ -153,7 +190,7 @@ static const struct pci_device_id *pci_match_device(s=
truct pci_driver *drv,
>  						    struct pci_dev *dev)
>  {
>  	struct pci_dynid *dynid;
> -	const struct pci_device_id *found_id =3D NULL, *ids;
> +	const struct pci_device_id *found_id =3D NULL;

[Severity: High]
This isn't a bug introduced by this patch, but does pci_match_device() have=
 a
use-after-free risk when returning dynamic IDs?

It looks like it returns a pointer to the id field of a dynamically allocat=
ed
struct pci_dynid after releasing the drv->dynids.lock spinlock:

pci_match_device()
    spin_lock(&drv->dynids.lock);
    list_for_each_entry(dynid, &drv->dynids.list, node) {
        if (pci_match_one_id(&dynid->id, &dev_id)) {
            found_id =3D &dynid->id;
            break;
        }
    }
    spin_unlock(&drv->dynids.lock);

    if (found_id)
        return found_id;

If remove_id_store() is triggered via sysfs concurrently, it can acquire
dynids.lock, remove the dynamic ID, and call kfree() on the structure:

remove_id_store()
    list_del(&dynid->node);
    kfree(dynid);

If this happens while __pci_device_probe() has matched the dynamic ID but
hasn't finished executing the driver's probe() routine, could the driver
dereference a freed struct pci_device_id?

__pci_device_probe()
    id =3D pci_match_device(drv, pci_dev);
    if (id)
        error =3D pci_call_probe(drv, pci_dev, id);

>  	struct pci_device_id dev_id;
>  	int ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D8
