Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0676F2D023
	for <linux-scsi@vger.kernel.org>; Sun, 18 May 2025 22:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747608608; cv=none; b=N52LgWZRLK+Koj2T8P8/gJQgiI8DRX4UxZtM2rfiVLJkWkubyzgNxs1ImCDE6JYmcZIoZ+x0OssvC5AaJQL91GdqjrsPz0nE6+BNjdGCY1IDGoeoVEvJu9Pniqkg+UWTCOHvEahu8nwym1KRI3UW3pKF9ya+BQHWGoQ5k9H3Alk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747608608; c=relaxed/simple;
	bh=Ex86I0ZvxrbfqTp2fbLghS1UXpowyli31R29CSu4lUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwIg9UK+0vaI5okBjH0PDezUh+PFqmQ8DF85PoYNmuuFAX+EoL6enBMfpD5K9JcVL6OI4iDQBe8Y9bhaURL+sonyO6BDsE05KbdCnC7SytdJtzcaTHebCY/dLENJAZqcgUfLNG1L6+JvjJ2Yp+8wiQOV0lUzre7C+i+B4fCkUM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MJn6Ry9e; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MJn6Ry9e"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54IM0O2E028382
	for <linux-scsi@vger.kernel.org>; Sun, 18 May 2025 22:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=InqaD2zz8IXPbJ4Cc2UGd8YB
	VpLuDNI5sRhUYI1lQ5o=; b=MJn6Ry9eXF4v1O8S5WC/ZKbfJf/AFj3eZKRLF1ka
	nKsg/wkVc7SBYhuU+fi/z6NjhDtXtmy/NpfzUDno378HW0FtDq1b3Z37/jX3goQL
	y+UUedCia3w4J64l7azu96t6ZDE3ONxkoipDIR3VrqlOppjUCedtlT+DWFxjBHXq
	d1bSRNfxQB56a1PhjChq9NbGS/+p0A0cpTXIG1gS21/f9gllhmh15t86lYP2hT2D
	akcem1A+98IPaQPuMa3IuXOdnX4QI6EKTsA6F9WrTHfW+l5ITmZhrbcM1P8qNKg8
	WiLR3SYQFqb/fWb0BuIOJT+FEoljb+GR1IQXPyARj2EN5A==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46pjjstgta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 18 May 2025 22:50:05 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6f8d3f48f35so12211846d6.0
        for <linux-scsi@vger.kernel.org>; Sun, 18 May 2025 15:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747608605; x=1748213405;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InqaD2zz8IXPbJ4Cc2UGd8YBVpLuDNI5sRhUYI1lQ5o=;
        b=ThQsONufGXDZX7KgQC/8px1ptJnwkwjiz+SzpwvJ5lj4quhhX7f7REygSDQzgxERvr
         0d8ZItNM/KUkFcaDeuD43ZgMAAxsBrACCODI8+suPj8dJ9y47IvxVJfrBf1/z04iEYmx
         6vbXvb1n3pR9ySx5N7P6XL07hEMDwtBt+m4n9XlTSNQgDOyqJS91dUG8IkIBcQPtO04T
         AQ+wWzwocVl1Q5kIeqnR+4gGFMMcx9aVcJWdef9/i4xzH/ZRiEzoqUl1b9roxDpLAO1f
         ty540RdSSvVutgJdvqc/5E7Uu3I25PwtMPw8qoQk67tR1sZ/M0z5cmkEhzfFQhNVpHNK
         DnLA==
X-Forwarded-Encrypted: i=1; AJvYcCWRnS2s/LJMbg4CkKlnY7sjQAOC86BLHDwWSMxL8hnNjQ+LV6hITTJlj2juSJfs4iSR8HZXirSSM3um@vger.kernel.org
X-Gm-Message-State: AOJu0YyYbm0+i8/8bwF9fB94yO3iCHdZTCLatOflnYVLCwrezYw9P2E3
	EP+LIhSvSxrMfHppvYniZslMNUZuLjSteMUocjfVec9ngP7skrrhxwlnoOmmyv6UBDPf+Q1nlM8
	7ToV0+iqxCJHwX6a3IXsxi3/fAJlvzn2kw7sWcO2IF+5aTBlpdH7AnVgjaBR4vUUh
X-Gm-Gg: ASbGnctO41XC+TPqJmxWnvD4Do1vkrQME8hJTLnLoXLn2DE2m2Btt2gOeTo9GnHEMc3
	Le3LGmhkCy8FU3u3uNcfXVcTMJA4Cgp5NO4UzeVPXzw+rqCQrxWUK5VU4YXSBlGxdGthKFoz2+9
	czuHsFb9NkNwkJ1PILyWXEHVksxRYCDPNstlD4SYQvW5TFX+XKvnxmPBYtfdT3VEa9Q0tps4oHH
	zVua3WxpaSAUPLygjpY9k+QqDYmt98YkPpcnNpYPD0Qudb3yFXoXVeEG6Toq2sB8c+PRAwqJn+6
	3aJ0jUMEX2lijhVjac4tYYUTOJMkJ43mr63H1RkoYuUvPwS30ydlTlMVGZWzngP4XWF745gmIBY
	=
X-Received: by 2002:a05:6214:27ef:b0:6f2:bcbf:1030 with SMTP id 6a1803df08f44-6f8b09542abmr153442776d6.43.1747608605130;
        Sun, 18 May 2025 15:50:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtI/P9Ic6fG3W/Sv6Mi+6qg2rT4HzkrU7ujx4sNi9OVmydEHID9pyDdwB/cwiUhNpxwl1dJg==
X-Received: by 2002:a05:6214:27ef:b0:6f2:bcbf:1030 with SMTP id 6a1803df08f44-6f8b09542abmr153442576d6.43.1747608604790;
        Sun, 18 May 2025 15:50:04 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-328085b8795sm16856181fa.79.2025.05.18.15.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 15:50:03 -0700 (PDT)
Date: Mon, 19 May 2025 01:50:02 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 01/11] scsi: ufs: qcom: add a new phy calibrate API
 call
Message-ID: <d7d2u5g3ikhx4plag7fkeeqint2766hjjplr4yoyehvqyfogkm@pcegku6arhfj>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-2-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515162722.6933-2-quic_nitirawa@quicinc.com>
X-Proofpoint-ORIG-GUID: Jr4eKk5UqKhEJJEmlh9So491552Em5Xf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE4MDIyNyBTYWx0ZWRfXzjhNvP+jy475
 JG0JrSkQ3UZx7SGxpMX4KsMktUT/MDxi+Cg3i266v5FtgDCtcZ+psSf6jEVDI9U/oRmaO4Mg1QW
 v8LobREuWcLCJs0lndCi4adUQaC5UrYgWAgrJiQMUxLi3bEYa3q+u8P9Hi/TLVs8LMQQX0+wiKO
 w+diE4eBEh/WZgV2J/8PnlrCs30HvBswk/BmseycgVC6wR3l0SBFzi/nY2eq+y+BNxVIILAX1qs
 PfnA9gujHrpD5qGb4GCnB8v60s+pzbvf8DaFpgrTzMK2RLNUNdYNMjvPe2uRsPY4NE5LdYovvtU
 YC4Zmzw5n2komyJdlwuwWKKfv19zjuXTtxlHCOkkO/5zKD1n/6AHh1xYsg0SYZyVd/rn73oV10S
 jeSl7S5xXn1CE9/VxtNseCABPcBY36JGHVuworOrogSfFov2EI3/lI1N2MMuDb154SitXfdb
X-Authority-Analysis: v=2.4 cv=K4giHzWI c=1 sm=1 tr=0 ts=682a641d cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=fB9s-OebfdFJWpWk0o4A:9
 a=CjuIK1q_8ugA:10 a=pJ04lnu7RYOZP9TFuWaZ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: Jr4eKk5UqKhEJJEmlh9So491552Em5Xf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-18_11,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 mlxlogscore=940 suspectscore=0 phishscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505070000 definitions=main-2505180227

On Thu, May 15, 2025 at 09:57:12PM +0530, Nitin Rawat wrote:
> Introduce a new phy calibrate API call in the UFS Qualcomm driver to
> separate phy calibration from phy power-on. This change is a precursor
> to the next patchset in this series, which requires these two operations
> to be distinct.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

-- 
With best wishes
Dmitry
