Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D32217C224
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 20:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719003127; cv=none; b=iWvEEY45TWU5+8VXtHKWoXJ7rGiFqeELvspNrXqoDgjzw4XYXzesFqv6H15gaHuJMoYorn9EUrYRy/PsFrt1mA07oRMcfPme2pXBRIaMNAo3sr40u+TVSpYBhmrOdXBQ6syJCiKeugS++eLJxkHKcS54eCF3xaC1/DWg9NDWMdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719003127; c=relaxed/simple;
	bh=U189B7G5pk3YGUGKkfishF3g9IV8OZ90G5i5YzFL1aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOlX8s/7cZ0dobwWAiHUKjF81eLvsn47XwXDGuZixT3CYXpATOQAm1s5tUgplpodZi4VH/NUQhyKimhIpQXLuB+m6GsTns5DO1UruRdYe0BU1ZuO06NqTiRHd1d3V4/JvPT09rHoM+rFWvsr2oNlCAsM/8Z0Yn+bh8SFcGAlxKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dE9fgJZz; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dE9fgJZz"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52cdb0d8107so1105796e87.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jun 2024 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719003123; x=1719607923; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R4XPxrZ/L3RzapuIA8BIheCmx0yb57X12BhvnLGioI4=;
        b=dE9fgJZz9W9to1GegmZd2UdtG5TkTNOFA650u9HAedZ8awqkVexI0F1brbIq8OSDAy
         L3IYnf48u2DcW8OKCoyjZ2T5m02hQN8u0NrdcOt5mSzCG5sQjjxVaTUfwLIZxg5yILqQ
         mhLgyH7v/rUqWUihZQPe1e18d9vjpuLLYWm6URn0h8AHlfh3qxRsT6zS+fiKpfL3YYk0
         SNMKfznEBApMLYAbVfgosEsYlVflW7n5lAUTa6AKVaOCiRarXFw6Ub9yhqaBtYy7cHEY
         kaDJ6mbSDgmIsI84Ewgl7jFAQ+Jis7AKlybCuRd5YW1Hz1eAkMAvfnc3AD2Qd8jNhwyn
         79Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719003123; x=1719607923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4XPxrZ/L3RzapuIA8BIheCmx0yb57X12BhvnLGioI4=;
        b=IUk0YNkCICGRKNZCa9iTzHpSKIXZRETXARE+Vhr89Pt576E1Hb8Nhr50k8DVmn6y56
         OXspfRCbEiovpkUcTEFvHmgAz3kT7R71WvxcnC4B6CR9jZap8zUIpGbDRJ7EeNRynxFc
         5eA71XqoLbwe6Srt91q+Og4W/G0/AFuwvMimbGwL3370uIP4yDaGc+xTB3iwIDwVDsyt
         NIoQJD5V9zjm2ButGYdKQEQBxDbMPjc9oPnDVKJUT7KIQ7cTWaSGXm7VwKzZ0yizwr2/
         kSi8CSmKM/Q65GgWOZ1hjwonpEiKvnutDTLXN67lksnQG2M9DnmEGQaxLwkTzXkL/6XK
         qrbA==
X-Forwarded-Encrypted: i=1; AJvYcCXdxRUDyr2FambFR3wZVZuu0ooxOtlUossX9jXY9fVVUFqx0SFywO2gY41uEWtwXlWXgFLa4jAQhXVsEV96itP/XHuUFiyQqtDR+g==
X-Gm-Message-State: AOJu0YyP1W88mdhlE91nBWZyfVdg4ergCNll+este75D6eUAIEVtMTX1
	NeBVXqMa5Klm4GeBd4UNaPDdLuMc+4tJYVe7ptfwVW1RPPepHtpZDpx9xt+iTt8=
X-Google-Smtp-Source: AGHT+IFxMGz3ka8LdrqSjdtRvrQYBXU4ww3QK4FDfwtssmDRaOcg8CC6y2g10PnWL3FURAUlMY849g==
X-Received: by 2002:ac2:44b9:0:b0:52c:d7cb:68e9 with SMTP id 2adb3069b0e04-52cd7cb6e9dmr1738852e87.60.1719003123088;
        Fri, 21 Jun 2024 13:52:03 -0700 (PDT)
Received: from eriador.lumag.spb.ru (dzdbxzyyyyyyyyyyybrhy-3.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52cdb53069asm166061e87.37.2024.06.21.13.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 13:52:02 -0700 (PDT)
Date: Fri, 21 Jun 2024 23:52:01 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"andersson@kernel.org" <andersson@kernel.org>, "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>, 
	"srinivas.kandagatla" <srinivas.kandagatla@linaro.org>, 
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>, 
	"robh+dt@kernel.org" <robh+dt@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, kernel <kernel@quicinc.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, 
	"Om Prakash Singh (QUIC)" <quic_omprsing@quicinc.com>, "Bao D. Nguyen (QUIC)" <quic_nguyenb@quicinc.com>, 
	"bartosz.golaszewski" <bartosz.golaszewski@linaro.org>, "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>, 
	"ulf.hansson@linaro.org" <ulf.hansson@linaro.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mani@kernel.org" <mani@kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	Prasad Sodagudi <psodagud@quicinc.com>, Sonal Gupta <sonalg@quicinc.com>
Subject: Re: [PATCH v5 04/15] soc: qcom: ice: add hwkm support in ice
Message-ID: <mwc3zbfst4pnbmxcdmdkhdqgsbrv3vdz5faqc4viifjwk6olfd@gc4pga5huqlv>
References: <CAA8EJpoZ0RR035QwzMLguJZvdYb-C6aqudp1BgHgn_DH2ffsoQ@mail.gmail.com>
 <20240621044747.GC4362@sol.localdomain>
 <CAA8EJppXsbpFCeGJOMGKOQddy0fF4uW3rt4RUuDTQq6mPunBkg@mail.gmail.com>
 <20240621153939.GA2081@sol.localdomain>
 <CAA8EJpqV4CW9kKLVUZgfo+hkSv+tn0t+k0McmHEyXNJUpsZF1w@mail.gmail.com>
 <20240621163127.GC2081@sol.localdomain>
 <CAA8EJpqytynwQrCAqqBsmx2XYgV5tsNeV4hpYzT6snqu+r8Wdg@mail.gmail.com>
 <20240621183645.GE2081@sol.localdomain>
 <CAA8EJprydVC6Sp8g9b1TOyxN8Awc33=MxKY8=Upi_zag=kDBHA@mail.gmail.com>
 <20240621201441.GA3850750@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621201441.GA3850750@google.com>

On Fri, Jun 21, 2024 at 08:14:41PM GMT, Eric Biggers wrote:
> On Fri, Jun 21, 2024 at 10:24:07PM +0300, Dmitry Baryshkov wrote:
> > >
> > > (fscrypt used to use the keyring service a bit more: it looked up a key whenever
> > > a file was opened, and it supported evicting per-file keys by revoking the
> > > corresponding keyring key.  But this turned out to be totally broken.  E.g., it
> > > didn't provide the correct semantics for filesystem encryption where the key
> > > should either be present or absent filesystem-wide.)
> > >
> > > We do need the ability to create HW-wrapped keys in long-term wrapped form,
> > > either via "generate" or "import", return those long-term wrapped keys to
> > > userspace so that they can be stored on-disk, and convert them into
> > > ephemerally-wrapped form so they can be used.  It probably would be possible to
> > > support all of this through the keyrings service, but it would need a couple new
> > > key types:
> > >
> > > - One key type that can be instantiated with a raw key (or NULL to request
> > >   generation of a key) and that automagically creates a long-term wrapped key
> > >   and supports userspace reading it back.  This would be vaguely similar to
> > >   "trusted", but without any support for using the key directly.
> > >
> > > - One key type that can be instantiated using a long-term wrapped key which gets
> > >   automagically converted to an ephemerally-wrapped key.  This would be what is
> > >   passed to other kernel subsystems.  Functions specific to this key type would
> > >   need to be provided for users to use.
> > 
> > I think having one key type should be enough. The userspace loads /
> > generates&reads / wraps and reads back the 'exported' version wrapped
> > using the platform-specific key. In kernel the key is unsealed and
> > represented as binary key to be loaded to the hardware + a cookie for
> > the ephemeral key and device that have been used to wrap it. When
> > userspace asks the device to program the key, the cookie is verified
> > to match the device / ephemeral key and then the binary is programmed
> > to the hardware. Maybe it's enough to use the struct device as a
> > cookie.
> 
> The long-term wrapped key has to be wiped from memory as soon as it's no longer
> needed.  So it's hard to see how overloading a key type in this way can work, as
> the kernel can't know if userspace intends to read back the long-term wrapped
> key or not.

Why? It should be user's decision. Pretty much in the same way as it's
done for all other keys.

> > > I think it would be possible, but it feels like a bit of a shoehorned API.  The
> > > ioctls are a more straightforward solution.
> > 
> > Are we going to have another set of IOCTLs for loading the encrypted
> > keys? keys sealed by TPM?
> 
> Those features aren't compatible with hardware-wrapped inline encryption keys,
> so they're not really relevant here.  BLKCRYPTOIMPORTKEY could support importing
> a keyring service key as an alternative to a raw key, of course.  But this would
> just work similarly to fscrypt and dm-crypt where they just extract the payload,
> and the keyring service key plays no further role.

Yes, extracting the payload is fine. As you wrote, dm-crypt and fscrypt
already do it in this way. But what I really don't like here is the idea
of having two different kinds of API having pretty close functionality.
In my opinion, all the keys should be handled via the existing keyrings
API and then imported via the BLKCRYPTOIMPORTKEY IOCTL. This way all
kinds of keys are handled in a similar way from user's point of view.

> > > > > Support for it will be added at some point, which will likely indeed take the
> > > > > form of an ioctl to set a key on a block device.  But that would be the case
> > > > > even without HW-wrapped keys.  And *requiring* the key to be given in a keyring
> > > > > (instead of just in a byte array passed to the ioctl) isn't very helpful, as it
> > > > > just makes the API harder to use.  We've learned this from the fscrypt API
> > > > > already where we actually had to move away from the keyrings service in order to
> > > > > fix all the issues caused by it (see FS_IOC_ADD_ENCRYPTION_KEY).
> > > > >
> > > > > > >
> > > > > > > > Second part is the actual block interface. Gaurav wrote about
> > > > > > > > targeting fscrypt, but there should be no actual difference between
> > > > > > > > crypto targets. FDE or having a single partition encrypted should
> > > > > > > > probably work in the same way. Convert the key into blk_crypto_key
> > > > > > > > (including the cookie for the ephemeral key), program the key into the
> > > > > > > > slot, use the slot to en/decrypt hardware blocks.
> > > > > > > >
> > > > > > > > My main point is that the decision on the key type should be coming
> > > > > > > > from the user.
> > > > > > >
> > > > > > > That's exactly how it works.  There is a block interface for specifying an
> > > > > > > inline encryption key along with each bio.  The submitter of the bio can specify
> > > > > > > either a standard key or a HW-wrapped key.
> > > > > >
> > > > > > Not in this patchset. The ICE driver decides whether it can support
> > > > > > HW-wrapped keys or not and then fails to support other type of keys.
> > > > > >
> > > > >
> > > > > Sure, that's just a matter of hardware capabilities though, right?  The block
> > > > > layer provides a way for drivers to declare which inline encryption capabilities
> > > > > they support.  They can declare they support standard keys, HW-wrapped keys,
> > > > > both, or neither.  If Qualcomm SoCs can't support both types of keys at the same
> > > > > time, that's unfortunate, but I'm not sure what your poitnt is.  The user (e.g.
> > > > > fscrypt) still has control over whether they use the functionality that the
> > > > > hardware provides.
> > > >
> > > > It's a matter of policy. Harware / firmware doesn't support using both
> > > > kinds of keys concurrently, if I understood Gaurav's explanations
> > > > correctly. But the user should be able to make a judgement and use
> > > > non-hw-wrapped keys if it fits their requirements. The driver should
> > > > not make this kind of judgement. Note, this is not an issue of your
> > > > original patchset, but it's a driver flaw in this patchset.
> > >
> > > If the driver has to make a decision about which type of keys to support (due to
> > > the hardware and firmware supporting both but not at the same time), I think
> > > this will need to be done via a module parameter, e.g.
> > > qcom_ice.hw_wrapped_keys=1 to support HW-wrapped keys instead of standard keys.
> > 
> > No, the user can not set modparams on  e.g. Android device. In my
> > opinion it should be first-come-first-serve. If the user wants
> > hw-wrapped keys (and the platform is fine with that), then further
> > attempts to use raw keys should fail. If the user loads a raw key,
> > further attempts to set hw-wrapped key should fail (maybe until the
> > last raw key has been evicted from the hw, if such thing is actually
> > supported).
> 
> That's not going to work.  Upper layers need to know what the crypto
> capabilities are before they decide to use them.  We can't randomly revoke
> capabilities based on who happened to get there first, as a user might have
> already checked the capabilities.  Yes, the module parameter is a litle
> annoying, but it seems to be necessary here.

Hmm. This is typical to have resource-limited capabilities. So yes, the
user checks the capabilities to identify whether the key type is
supported at all. But then _using_ the key might fail. For example
because all the hardware resources that are used by this key type are
already taken.

> It is not a problem for Android
> because the type of encryption an Android device uses is set by the build
> anyway, which makes it no easier to change than module parameters.

If AOSP misbehaves, it doesn't mean that we should follow the pattern.

-- 
With best wishes
Dmitry
