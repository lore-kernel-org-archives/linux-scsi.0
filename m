Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51D9386425
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774896151; cv=none; b=lrtmW3pSMEzrxbJ6M78D7S7g8LBlxRaqcqqY14S6W2FuSC4qNyeNg1GdEq7TxKF7M2gmvpocgiUvZz47EFIjDva/7IjNtsCfIKao14hJeGdWPIZVN38nKTM1JyLV7Qei3kN5OT1LPVaeziTd5ztqvdhAKysQMdtATr91SrRzQkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774896151; c=relaxed/simple;
	bh=wEZylc/vOUG+ypTEQXA2Jh1x+qldW7FIOT9m9zc3voQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWHC7ViC8RDin+dxdIHu7X44Pd4USFpg1jMJ2PVjbONOmyOOi/Q6dKvki2mSnXq2hRRKc+Kc7h3JPLCu4g/X57VsXcLJWbrVtWr+rmyBOiiFzwulQzORU1wX0HFH/c6vCK8Z241pmW5cTURI404Dxvr7F/ulQ7/Kf8saGO4kY88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Lg4mFrYV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e6DGPs4H; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Lg4mFrYV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e6DGPs4H"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UF3LDU3539569
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 18:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=tmSly2krkyEPd3C1QckzdIz2
	IUKLQUpW62wr+IkZxLo=; b=Lg4mFrYVXlfkHbSHjzYG742sLp8Hw8PbBuqXveTw
	o7U+tcLPv3gt3ouVf0nNtzUc+oQB2a0tDB/7h8AIW9t7DUCmi6mVGSYfMRtNTQBM
	rlbXmLr1nN5nMQFlGGnG1LoeJBut5sP41sHthsDK6u9ugV6QfjmhQ6mJtmR2Dm1h
	fGQV66ppZo8A4qNnaxbBHuvA3IF/IeJmiL/I+OhmESb5H9BbUFPGXGHJmme1TQbg
	iUqA2IW8fY8zQawH9rh5/SKWVVbCcoOM26JOdG7Jzb/g1H0Ul3ZGUSt1bn2O1FWZ
	5wv92hzXy9B8Y2T+uuw2V0bTSuVdks569KQI67RrlBxbbw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d7q59t26w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 18:42:29 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50b4b81c632so156634661cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774896149; x=1775500949; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tmSly2krkyEPd3C1QckzdIz2IUKLQUpW62wr+IkZxLo=;
        b=e6DGPs4HZEMZbC5/NN89qa9uEZuHPB+zd8V9jQqu43SXmswz3khvO6GnVSiExw0l44
         GgTBC0ap1TWdYsy0Iv7nPAjQAmLEUmWZ2ekzpdyCf1pb3QU7/C0zd7pAF6Y5SLdebS13
         aI0co537aaKfTsHzVLy1u0wzI5xqdw2EwXRQnBx+hCjYRuJWD8pNttHjgvHc6Cc/oN7l
         iv/nNwCXRXmCwwsrvFxqyrKyLZEztHpYhlP4fkDYyjeCcIbUgjMeLB8cJyoas8TqMpvI
         idC+vy/TkvnIpw+sWIopwqbJqNnbjopn8Tm58byXL3qjGRi0LxyKH1F+t9F5ABN7UH40
         2YHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774896149; x=1775500949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmSly2krkyEPd3C1QckzdIz2IUKLQUpW62wr+IkZxLo=;
        b=cZet9W2PHYwpiHBLw0QCZ1zYXr7aZAtQP9r7Qt/qaVu31deHd7PkTtXl5My2sTpanq
         BftnrpHf18L41KikwG9Us/2INCbF+30gs3NKKzZq07QPSiwHV1oMiCvNMTWwGxmR/Vc0
         ggnxYakBvNfWpHePQlDOOLjztejH/H03j8rVipiUiS/tza+ggEHy3xj3xwkpvYhZy2Df
         aQqs3uF1BA9fwLNtf2KGLheFpsC255gz4r/2yqzrgJw9jhvF5CJaqWJriBa7XWier/im
         9ATUlkSwTQwm6wDxTlRKwAxbX7EvDXltta6S9qFCxiRbqJV9LaAVhdR90YkQyzgeP5RN
         C0gQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6g5mzYw182dH03vthYtnHrUQ8EmtkJHIZB/Hy4XBZaSfkVOXBnwnRH79Ei8/wYM4LrLQgxa3Z9HFb@vger.kernel.org
X-Gm-Message-State: AOJu0YzZLQGIfRkzps5Bq7bEXt3AdKJOJ6lskHQjfCg45lnQQWj1H593
	X3V8YHaCuhYsO7nN6NQqnxaMeAzHIv8W0EnqMmlMWvV65USKgb+PTDGmnTyI8RKIJEavIesUttI
	ZiNBtlGnPunIbPKbItBoTAHN2P4jDgpuGmwhFENDt/4Ofc1852PqLuRv5JrBtX2QO
X-Gm-Gg: ATEYQzwaMjaWD7cFMQb99VvcqKCYN9SmAzUEZvqH+2/Pou44N3ueuG/gh1zvz871BRZ
	k9TBsa0bQifKZOp0gbvypoOXzIpI29zm+saZqs7FAhBcMRNCesh9E9+MWS0lI5TKoOECLKxHT9e
	0jh4He4j30yuYTIte+e5e2tKeQAUmRXEAMSVB4yAnbR0T531r6MRcWR2wbkbr714pnyOgN9zcZY
	IqrwV5tQm1hOR4zYFN/0pwNMXqPlJdGZVKv5MsWmov7aBHNUmFm9lCZeyAnsq8hZAphFVMjCfb8
	DMx4mWKt4wA8FbYw4VpEDBWTP4hMiX2OxK7ZNmEgYBShORyYqMIy9eAXFNVsOWN8/5UEwmEXERq
	OjxCMF3yZTYqRzJaXg9EgNWf7K7CqW9WkHFYehbukVy5WXfZRuS8PY2eJNzoFQYksy7DGgdVyB5
	+1srqazYh6MlzNaVdoqLDO6H3gpGWE7bpyQVY=
X-Received: by 2002:ac8:5914:0:b0:509:172f:bd5 with SMTP id d75a77b69052e-50ba380a2bamr194038161cf.4.1774896148938;
        Mon, 30 Mar 2026 11:42:28 -0700 (PDT)
X-Received: by 2002:ac8:5914:0:b0:509:172f:bd5 with SMTP id d75a77b69052e-50ba380a2bamr194037551cf.4.1774896148325;
        Mon, 30 Mar 2026 11:42:28 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b13f435bsm1815809e87.9.2026.03.30.11.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 11:42:27 -0700 (PDT)
Date: Mon, 30 Mar 2026 21:42:25 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Ritesh Kumar <quic_riteshk@quicinc.com>, robin.clark@oss.qualcomm.com,
        lumag@kernel.org, abhinav.kumar@linux.dev, sean@poorly.run,
        marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, quic_mahap@quicinc.com, konradybcio@kernel.org,
        mani@kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, vkoul@kernel.org, kishon@kernel.org,
        cros-qcom-dts-watchers@chromium.org, linux-phy@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        quic_vproddut@quicinc.com
Subject: Re: [PATCH v4 1/2] dt-bindings: phy: qcom-edp: Add reference clock
 for sa8775p eDP PHY
Message-ID: <yex4vskdbtvodzkkxbs6yxkeiz5bb3x32f5nx5qklf6oyexroq@zspg26phklt2>
References: <20260128114853.2543416-1-quic_riteshk@quicinc.com>
 <20260128114853.2543416-2-quic_riteshk@quicinc.com>
 <gurq34svc5p52bqx5qwkgjmschzcbklmssjzmu2tg5wzgppkft@c6nrw2ageyp2>
 <c77ff64f-57d1-4495-bfbd-986644aad71d@quicinc.com>
 <acqGFwaVFQ3ZNmlR@baldur>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acqGFwaVFQ3ZNmlR@baldur>
X-Proofpoint-ORIG-GUID: 79Cv02TKjSgzfKkxUe7b4Z7nHl-cZqhX
X-Proofpoint-GUID: 79Cv02TKjSgzfKkxUe7b4Z7nHl-cZqhX
X-Authority-Analysis: v=2.4 cv=EcXFgfmC c=1 sm=1 tr=0 ts=69cac416 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=COk6AnOGAAAA:8
 a=EUspDBNiAAAA:8 a=Ns0KfnHm5iy1vUwMj8cA:9 a=CjuIK1q_8ugA:10
 a=dawVfQjAaf238kedN5IG:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDE1NSBTYWx0ZWRfXzTjnKm45aEFj
 PHiDkASpAGPPjNCGNQipvsHcm+yUD4dSTmYY7J/JpJY+jM9v5uRMkbvYIU9BpLmDCEnCEd8JAed
 xZ1yg/4X89rfR+N5htzUNdhFEDqArworHyG20T3HWWGof83kPL22oiG2820HHniFb4wMCMJmEoB
 zXE7KaAUev4aiUVU+X+H61MdPjqxCk4HgDKEt9aYO5O6lMxBpa/uuc3fK6IQXDvEEwe6PRFj9Ep
 OZ2Nhg39Dzlf1Tk0B9Hmtnp+cfwBfT7rE4/nPN76BG+5OMx2+7hOp6N/ubRssd+ZQC2L14AtRgw
 y+qYugOqY5ZFiFnS1T8p0lq/TTCVCQp3uwRtX2s4XqDnqgfvcTvWpOpbYklKCBuWL0+vPfGn0F5
 51u4n4egExfFmfC1aZw05m7Tk7V6wMDzv1TkIccfW1b7Dp3kbzm3kIaE23G7h53HKenq1vjFge+
 w9aIs50z2hyz7nY198g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-30_01,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603300155

On Mon, Mar 30, 2026 at 09:28:40AM -0500, Bjorn Andersson wrote:
> On Wed, Mar 11, 2026 at 06:37:31PM +0530, Ritesh Kumar wrote:
> > 
> > On 3/5/2026 12:27 AM, Bjorn Andersson wrote:
> > > On Wed, Jan 28, 2026 at 05:18:49PM +0530, Ritesh Kumar wrote:
> > > > The initial sa8775p eDP PHY binding contribution missed adding support for
> > > > voting on the eDP reference clock. This went unnoticed because the UFS PHY
> > > > driver happened to enable the same clock.
> > > > > After commit 77d2fa54a945 ("scsi: ufs: qcom : Refactor
> > > phy_power_on/off
> > > > calls"), the eDP reference clock is no longer kept enabled, which results
> > > > in the following PHY power-on failure:
> > > > > phy phy-aec2a00.phy.10: phy poweron failed --> -110
> > > > > To fix this, explicit voting for the eDP reference clock is
> > > required.
> > > > This patch adds the eDP reference clock for sa8775p eDP PHY and updates
> > > > the corresponding example node.
> > > > > Signed-off-by: Ritesh Kumar <quic_riteshk@quicinc.com>
> > > 
> > > Is there any reason why you didn't follow up on this patch Ritesh?
> > > Looks like it's ready to be merged.
> > 
> > I was waiting for patch to merge as there is no pending comments.
> > 
> 
> It's been two months now, if you want your patches to be merged please
> show that - ask the maintainer for a status update, ask a colleague to
> send a reviewed-by...
> 
> Perhaps the maintainer lost track of your change?
> 
> Perhaps it's not clear that the change "need" an Ack from e.g. Dmitry
> and then it should be merged by Vinod? Because you're changing two
> different subsystems but leave it up to the maintainers to figure out
> how to deal with this...
> 
> 
> Either way, show that you want this to be merged, don't just wait until
> the situation resolves itself.

For merging through linux-phy:

Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

Vinod, please pick it up through your tree.

-- 
With best wishes
Dmitry
