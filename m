Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2128CF77
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773898586; cv=none; b=Hnu2oYKDy2A5cWJDSPkqq0Kxbyi3uJzZO4BibNhbafozUZrsxONkTykNrbW5iAqddDHCrm3xiAeIITd+07p7wWtakmm/qHt/xHVSd72N8YLn/hjy+RQwTF9ArBkBDneAQ0tpGFe/n3BpRN26EFQTfzRa0PZk1zsfBA2TKfvZqZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773898586; c=relaxed/simple;
	bh=SK7gP3AdRB2weRwhUuhaO5iljg38WO1Y1+ShrFidEb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+/E9JbCf1Sh2HK1uK2L5qB1jzceu1/e3cag/wctcZIKyf8r/Ah3Q7PjGgrABsGKm99A20+I2UL7uRcEtjCmaoy04+svDWq++4vLl+BIpETqoxzpfafQ4zkDQZ2ZA8JQ7e0EdbMQbLHSzispIyQmZX6OvKv22Q0KQKiQ1HK22QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hMlKPRU8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cJevdxLe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hMlKPRU8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cJevdxLe"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J5XN7L1369776
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	a+6eVRTkI5BP0q9Hzgp+FpLtQ3rpJVvxCo062+FaU84=; b=hMlKPRU8a8PGc+hK
	Q1XF3agKNfoO02GGtokawDrQHwhSuwkGgwni1/30hGZZx0Ymaky9tfllw4A8i0pT
	NPLDnIevrpEAmdRfiZri+itYhm3jx/l5XDQAdwaqQGCbuZS15mOLctBBQwjYVJ3l
	FVkyE4sxyw/yT7cL0s8tmBod0OJTd9WJgh3IEM6tfNtRVOaklAPRCL3tQ3S8noKP
	iUU9gB5ET0UtqKmesODdS04Iqb02UvGmTuV62+qOawxzwm5FEFLQdDMDI8wWr5u3
	PpIA1drBlIqSt1LRg1Ltt8KqDFX1Taze7KwPzIUww5A4qnm/EkRt9V9cArtw9nhm
	awQvtA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d0akxg2w8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 05:36:23 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b051befbb8so11611525ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 22:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773898583; x=1774503383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a+6eVRTkI5BP0q9Hzgp+FpLtQ3rpJVvxCo062+FaU84=;
        b=cJevdxLexZel1s841LHlG1jLE9zKUhtfYcgsGCFzalcqEusZLHKIVU3IsifrqaNOKA
         CDH6lL5VB5IKt2ElMJQXj9l72H1MEwVrjdwVRRvQ/+sURmtOVq+NEw+YdO6U4wMfsGky
         tVLuu5Bcm+lRawH6UlhFGwJ9BrdirGNf9tt19w5KYADRBW0G29q/GTDeKerYefcysCSX
         QNJHDo5Gxs2nhxqUvWl0MjIBBdLwg226oKeyS1AlW//fW2ustO5xy8mo7UonC7tSLkeF
         2qtj5jzfcLs5f0W8K3+wX16+UAGUaynn2E6eSXcoJCPd5vPyMFAR+Ze2En9+B1j6706H
         bynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773898583; x=1774503383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a+6eVRTkI5BP0q9Hzgp+FpLtQ3rpJVvxCo062+FaU84=;
        b=jBNlXlpXwpPmOlMAtOCKXC6ZltUJ8fUDrBUZh9a/I7lsi8KKw35/UHeBE//nUd401n
         6ru1AcVwNsXV2q4svWUh5+++r+Unw2gn9wxwEv9CxqZOo296jprnnYoU0oKHErcKVln+
         7paQzLQqC6E2VD8aW7rMpTE7+Oiwo0MI4SNycy8RkYjTRy2oxVr1vvSf8999UbTK9mkQ
         eL2+jjq1DBpipx8NWjKJMEcaiO8v6kMn//M+Sxg/anKIPa6G2RzEgx1G+x8LD0oSw+Dc
         XlG1J5O8FMCBJxWK673iiT9prSZr2DLJARNd6+jwmj0lJA+t2d2QzDYbTQnqlFtt2ZWe
         w/ow==
X-Gm-Message-State: AOJu0Yzbsi/4huHWwKtZjtIT2ZeiUswhWWM0HNMzFj2QsAYwclFcpSvH
	7xj6NKJHiMJ73pECtLmqBql7upBodeVow1S9yKPyKKkJkqgu+biEh4xcNJwyBRWOyxuBnk/5NY1
	m4PpFBJQq0ImQlG99bIaNHKcBcyPNKTl/8+sGHmHVUES3XPriXH8oLTjvvN4dFFxDd4OWfTkY
X-Gm-Gg: ATEYQzy1HS4bTOUjQKxxIT5MvzuJRFkN4aiIE+pdSrVjqN5+ChfOWJLnG214jnGVrJS
	oB3tGyUmrUTNIEwyHtVxldoIAlOlI7V6SpExGNX1F3/pN64RDNuGpmADYZ7VCIsmheuc+76a8pC
	kX1R9XqsxdO9q2hZX/bz0VT9bnOwJBEfrQ810leADAnWapgsaIlS0zqVuH4WmXLcSpwUDXBe4qn
	IFRo6ZL4MIFNV1tMEo9roCn9HgsGGJYLd1z/HnaBUXR365GybS6Hq5/rNveVvbyBEe2O+e92Rl7
	PE3p1BM68ZCLTcD3sgjVYHxcFQsDCN2RVKIc3YV8SB3Xj0gl1W2WBM7M1ZpPabhnAlvxqAXUSaj
	YlvrRc82+OpfbihSHHC9aD3xh7mNqPfsK+pUNPEFo0xhxk58LXRg48TTj1wc0/PciGBQVmzpFy9
	d+JyyYSS7y5w==
X-Received: by 2002:a17:903:1109:b0:2b0:61f8:9f01 with SMTP id d9443c01a7336-2b06e3e18famr55996295ad.44.1773898582799;
        Wed, 18 Mar 2026 22:36:22 -0700 (PDT)
X-Received: by 2002:a17:903:1109:b0:2b0:61f8:9f01 with SMTP id d9443c01a7336-2b06e3e18famr55996035ad.44.1773898582319;
        Wed, 18 Mar 2026 22:36:22 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b07a508f00sm9565725ad.80.2026.03.18.22.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 22:36:21 -0700 (PDT)
Message-ID: <910ef3e2-76e5-493e-808c-73132d939864@oss.qualcomm.com>
Date: Thu, 19 Mar 2026 13:36:15 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX
 Equalization via debugfs
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
 <bf64badf-161b-421a-a9e6-76e6679d5c9d@acm.org>
 <d537b40f-70d4-42f3-bed6-616da2489950@oss.qualcomm.com>
 <c9df8dcb-4711-4678-8759-c0c72b5d5f8b@acm.org>
 <af0553d67deb4ece5e16041747f4999d2c95852e.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <af0553d67deb4ece5e16041747f4999d2c95852e.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDA0MCBTYWx0ZWRfXwcxlQS6xsPCf
 0wVdzGC8QJ/MfBvHcJSFnYGZQCxiJPShW26Hsj0cVZCen8BODCcnTzfL64yZuYqgh4VGp5d/Byz
 S4KM2mhPmO8cdtuE9ZclmpiTyRk1BUiFvKkdqGRBTemVDFgX+xrgKSqB6hwZgVnewcaDctQrjSE
 WnjmohvIVGNTrg+hHMozsFFOa3v5UckJg6SCHzYRgJGE59SNkn4IGSXd1OjfzuwUVmQG45489OH
 4trtxJ18Gzaf5H0IzrvkOZWxCxKZXnBRzXoyKWYP2iP3ZUk7N1rytLa7GihwDoBDXEkL5UtkAkp
 yMnxkrqK7UV+XfojT2bVu/+rUEtFUcbbIqdAntnXqFgGdJTFrpbBsNASoH+zO+/vHfwM8Gv7vVG
 E2byRUqoEwd34IWHqXMkEeSl49ioT/rz2XusL1BhwDyk7PL3YBX0FLf6SV0vhBkkjwEYzYbZYTn
 gp8ly79Ac146XofyFRA==
X-Proofpoint-GUID: kaQaRIj-8BUnK7-UpQ-iJA__BnPqAVtz
X-Authority-Analysis: v=2.4 cv=ZeMQ98VA c=1 sm=1 tr=0 ts=69bb8b57 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=lZOxv685zBznO1DyOMIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: kaQaRIj-8BUnK7-UpQ-iJA__BnPqAVtz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 bulkscore=0 clxscore=1015 spamscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603190040



On 3/17/2026 9:05 PM, Peter Wang (王信友) wrote:
>
> On Mon, 2026-03-16 at 10:14 -0700, Bart Van Assche wrote:
> > On 3/14/26 3:45 AM, Can Guo wrote:
> > > I chose 'refresh' because the code conducts more than just
> > > retraining of
> > > TX EQ,
> > > the code also carries out a Power Mode change after that, and only
> > > by
> > > doing a
> > > Power Mode change, the new (optimal) TX EQ settings are really used
> > > by
> > > both Host
> > > and Device.
> > 
> > Thanks for the feedback. Not sure what others think but I still think
> > that "retrain" makes it more clear what happens than "refresh".
> > 
> > Bart.
>
> Hi Can and Bart,
>
> I agree with Bart’s opinion.
I will move back to 'retrain'

Thanks for the suggestions.

Can Guo.
>
> Thanks
> Peter
>
>
>
> ************* MEDIATEK Confidentiality Notice ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

