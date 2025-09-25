Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C9A30CD92
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 19:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758829797; cv=none; b=eFHZ6VQs1U9E73kV4YfeSispy1FKVKrOp5j7U6PxROrA5W2sIbhW23817IgmxvjAl8PTmOU2VnvWJtL8e3Gn1I/FQSITSKgWucJhMxRC+gxEBxSCHC9U9YAh7ijJbmLzCTB2XDMn49Ga2Ixdls5ZMGalFCKBV+f+gc9LUPpTnsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758829797; c=relaxed/simple;
	bh=fy6Q0ZaKMfLx9uRS5uXQisOpubyAV1GiFDLk4s0TE60=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MO2Mw/e8gDP1/OBJ/0Hs0bYa4DiQnR7YJ/sSHr4FHfesWQsdxRRRdEg0qDpea4WDhQIHRgSAQbpNFAE+AuMxDSsw12mZ4eteu4ecBVydHv6fMdH3a/hgfI93BhWzoYHDmmEc/QyyVCACZX60PzLKCnpjnTnGqOO+fFkE2Hp7Bmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=fail (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=ioVc8dgl reason="signature verification failed"; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="ioVc8dgl"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id umcxJq9143ylI9Vf; Thu, 25 Sep 2025 15:30:56 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=xudL48fM9Z6IOWDFUL6jSU7YNm2a6NjrHcWQMpNKICk=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=ioVc8dglziMgbe+Pk4Vf
	bKOPa567RVaCwOpuEAmSRBa7VlFjqYkc3d/qz/Cmi+EhgcLIgL0gUO2hjX3EKjBSLkLw+zaLgfFNB
	65HEx/3+sxoC36Xh7xzgeyUCf60TLeBft6WLx5LiNaHZHuttsH5S2mtFUmyqhuuEhkSywO0aW4=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14213338; Thu, 25 Sep 2025 15:30:56 -0400
Message-ID: <9ef32bd2-1370-4e57-a696-7151c8e46976@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Thu, 25 Sep 2025 15:30:56 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/15] scsi: qla2xxx: add back SRR support
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH 14/15] scsi: qla2xxx: add back SRR support
From: Tony Battersby <tonyb@cybernetics.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net, KERNEL ML <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
 <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
 <8056aa80-7e5a-4cb3-804c-d9c7f8bd6d55@gmail.com>
 <46422ab9-9088-4d9c-b93d-31083f8b9398@cybernetics.com>
 <ec5bed6f-195f-486c-8905-bf63c663c212@cybernetics.com>
In-Reply-To: <ec5bed6f-195f-486c-8905-bf63c663c212@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1758828656
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 3432
Content-Transfer-Encoding: quoted-printable
X-ASG-Debug-ID: 1758828656-1cf43947df3a6b30001-ziuLRu

On 9/25/25 13:00, Tony Battersby wrote:
> On 9/25/25 12:04, Tony Battersby wrote:
>> On 9/25/25 11:30, Xose Vazquez Perez wrote:
>>> On 9/25/25 2:49 PM, Xose Vazquez Perez wrote:
>>>
>>>> If you want to review the firmware changelog, mainly: FCD-1183 (FCD-=
371, ER147301), FCD-259, ER146998
>>>> (from 9.00.00 to 9.15.05 [06/10/25]):
>>>> https://www.marvell.com/content/dam/marvell/en/drivers/2025-06-10-re=
lease/fw_release_notes/Fibre_Channel_Firmware_Release_Notes.pdf
>>>>
>>>> It's look like all 2{678}xx devices/chips are affected by this bug.
>>>> Perhaps the Marvel crew could provide more information on this.
>>> 267x, or older, is still on 8.08, so apparently it's free of this bug=
:
>>> https://www.marvell.com/content/dam/marvell/en/drivers/release-matrix=
/release-matrix-qlogic-fc-sw-posting-by-release-matrix.pdf
>>>
>>> 2870 / 2770 :        9.15.06 FW
>>> 2740 / 2760 / 269x : 9.15.01 FW
>>> 267x :               8.08.231 FW
>> I am still trying to figure out what macros to use to test for the
>> affected HBAs.=C2=A0 So far I have:
>>
>> if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
>>
>> But all the ISP numbers are pretty confusing.=C2=A0 I have a number of=
 8, 16,
>> 32, and 64 Gbps HBAs lying around to test, but I am sure I don't have
>> every possible model.
>>
>> There are a number of items under "Changes and Fixes from v9.08.00 to
>> v9.09.00" that might be related to the problem that I was experiencing=
.=C2=A0
>> For example=C2=A0FCD-1076 sounds similar except that the SRR problem w=
as with
>> the CTIO queue rather than the ATIO queue.=C2=A0 I could expand the "b=
ad
>> firmware" versions to include v9.04.00 - v9.08.00, since=C2=A0v9.04.00
>> introduced ER147301 and v9.09.00 fixed FCD-1183.
>>
>> Thanks,
>> Tony
>>
> This is what I found by checking the PCI IDs on some of my HBAs:
>
> not affected
> QLE2672 16 Gbps ISP2031 8.08.231 FW
>
> affected
> QLE2694 16 Gpbs ISP2071 (tested)
> QLE2742 32 Gbps ISP2261 (not tested)
> QLE2872 64 Gpbs ISP2281 (not tested)
>
> So the following check should cover them:
>
> if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
>
> Tony
>
Here is the updated version of the function:

/*
 * Return true if the HBA firmware version is known to have bugs that
 * prevent Sequence Level Error Recovery (SLER) / Sequence Retransmission
 * Request (SRR) from working.
 *
 * Some bad versions are based on testing and some are based on "Marvell =
Fibre
 * Channel Firmware Release Notes".
 */
static bool qlt_has_sler_fw_bug(struct qla_hw_data *ha)
{
	bool has_sler_fw_bug =3D false;

	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
		/*
		 * In the fw release notes:
		 *   ER147301 was added to v9.05.00 causing SLER regressions
		 *   FCD-259  was fixed in v9.08.00
		 *   FCD-371  was fixed in v9.08.00
		 *   FCD-1183 was fixed in v9.09.00
		 *
		 * QLE2694L (ISP2071) known bad firmware (tested):
		 *   9.06.02
		 *   9.07.00
		 *   9.08.02
		 *   SRRs trigger hundreds of bogus entries in the response
		 *   queue and various other problems.
		 *
		 * QLE2694L known good firmware (tested):
		 *   8.08.05
		 *   9.09.00
		 *
		 * Suspected bad firmware (not confirmed by testing):
		 *   v9.05.xx
		 *
		 * unknown firmware:
		 *   9.00.00 - 9.04.xx
		 */
		if (ha->fw_major_version =3D=3D 9 &&
		    ha->fw_minor_version >=3D 5 &&
		    ha->fw_minor_version <=3D 8)
			has_sler_fw_bug =3D true;
	}

	return has_sler_fw_bug;
}

