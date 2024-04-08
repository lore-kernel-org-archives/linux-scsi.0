Received: from sonic305-19.consmr.mail.sg3.yahoo.com (sonic305-19.consmr.mail.sg3.yahoo.com [106.10.241.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F847462
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 05:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.241.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712553829; cv=none; b=Nqaz/ZEObNJ6H5Ssx18oLc29/XZHoCARSE/gwnxmL6oJbDX95BLQMNWJ/30264yC43Kt1lfLHczkXmYEYHdo7I9mqwtydZjJEvrk/Z3C8rBeGUNYukkwqi00D1Tqd14PEWv5+F7BIKIxp0zwaQ70OO7hbYfSOAq8XNgnBKZo9MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712553829; c=relaxed/simple;
	bh=PReI1OJ5NbQ3wJ+SPio2KV1uPPookuWfMPRF03SjYkA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jGyQgLpLzdAqOhfLIHN/C/kUPOOqVEf7/MHErJg6C5VTIpQwcJ1tOOp4ao8GacOE2j9GLHGcVzv7Ur4TaBJZV+4mejch3Iv3iJGeu8fw7RdT8/6nx3UC4qmKVsAUaB1Ld9PLVgesz4Huu1CvNV1svw9iO7DQr0PPwJZMiQrG4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=fail smtp.mailfrom=fedoraproject.org; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=lJHOKAxu; arc=none smtp.client-ip=106.10.241.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="lJHOKAxu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1712553818; bh=PReI1OJ5NbQ3wJ+SPio2KV1uPPookuWfMPRF03SjYkA=; h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=lJHOKAxuNnQJZRi++GwoFwjLaUvcfPFxE8XF876BIzRNdXg5Ksuo+yl66jLXEpWd4WBKQ4ExIPzvlsWYS/CYrhv9nMxcOGMbbtBHH+wIMTUKcoX1cfahAru74ApIs8kuLfmCgQSlfSbcDJTYUpgx02xkrj1yOaesRDVXtFk8Ochh40AeFFP/H+kngO+D7eNb/w+bBNzm0zvwOz3P4yO6PxhmE/TrXSmWzwAzQzFPz/96Wp7mx/n00FAE11I2UhqYGMthG+V2UPrrIhXigZMxSwy/3kIjWN31JFjmwz+cptpVPFFwvUEFNCu9KzWkNz10YQho/OvcyaWrsY+m+wx+aQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1712553818; bh=rJJxNGAIw96xsYpd2Wa+w4ntdytOTxLrWa+AjYCytlB=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=NILHldmUnS20GC+xKSst0925fgCeYLedWVNsEq1ksgwWFnLJQWai+Cowp2FFVyqf+Dd/WD1pgDHpvRwOa8iLsWSgvOLfKsbmCN/ejeKF1uG1hzaYPHt7KsoonxNRYsSEheMmNXy6ekxbuHZzOyH24thJu1JMtXUTEoetoQE+G8tg47rtUfdgrMtqayyA2Vr4SUajAKn7KAKPRAPoV1p4oKhIDrKVpD/EXKms2QEGh0ocr6kUi79kFp+bGOa3/lvYzMOgX2SccwA2tIKgOYWcfhD2QXC6zl7jd2TGEP18EZt4BlDt07gv+FmtiqdYXTFv2Etq9EVd4S4rOTJPRWq1dQ==
X-YMail-OSG: 5kHQiTsVM1nzos_Z.Fc02SuEgVFlt63c9HTLhgVnvBRa17nX_ayhfmvx1CiKsEU
 dhNKy5o9KFlt3.7v1H4LYqPbzXJmEmjn9mOSjpou.YgSogue6acDS.x7OA7.Y_vM_H99uD7x01UI
 VthNuXdF8cdWO13ztew_etBGwgwwBt1_4T1z1ZI_ugt5nhvGEEaTTeOw7qqDhvEw8yMVUOF18e39
 _6UXjQGQLBxkpW5fW5vKbfgPcN9AovyOKdNgzsrfqwgXxEtBHaosBcI16z.YeVYTJvt8VPhGmDiq
 cQZPDfIxWBh0IkLtnJBIKvWeoCWRrHLMlDPIMVoGeUqUmsu8CcRNnGKEHdYysc5wBJ5ax4VDKIUk
 njrVv2fZ4aj43D4LKjfkEeuluJTTtgesM2kmrHjI047AIJtdn8bo.hCT8vP7eNyxnmuogDKzKlkl
 MmN0Es3Je247CtgbvqJfDsUwPdngnyFF0RUUqI1g6xuCsv8KIP87YwAAbtspHF7KhVrQMhwb5a7j
 cWa2PxBgd2nlEU0SpjrgVe47ev.5OmG20voVCQ3MlngS1HfyLtur9kZRd2LEoQ_iCLrjjFaaNNnU
 a90czHUP6bbxwPjGytNFnCr3.U1QCIp3SaMG5i1kXD34TLqGmO2fLfq_21ASpJCBWND9vrvRyNMq
 PC3fHJ8KH0LHd6a03qq6eEvPOkl1SUgAikLDGBChgdcMI7x0_sFO38iFbBpZ6U3_oYgFMPYxE5oY
 RnnqEupKL2EKVl3p2eN4tueYLW0vhQgeH38fvOKVSDQAyaDjevHG12CRP5AkGXw0kouL6YdSNFjg
 fXB96jjEbCm_iOsDPXZWi5uTJZXuGktQK0qrWTf_G2YPKgv4.FfaAvNi.eAFl4rNWrDUcCY676ZK
 z1KTdJtCIQC5_vKxmefNJro.bgI5wEB1mwDXI9bVkB.GbxOydXsqR1LA6MFvibXnmOxOftGDZWxr
 TJKqp8VT6_hFDljpqP8pXFmMkDRefNHxIdlqOthLTkTJopBj29S7r9cAIQHV79yZkuVM5sL.OR3e
 KWWjpdfj3knHRi4KYqkG4IJOkbtRr9cpAPDKWIJ76nRALmy9shjl4NOzjkgBSuEF4eqv7tUNRoEz
 9cmrS_m7MogY.1bfOXDXB7Oj_Hy6.1FkfYgUyVt1bZN5Y_W5t0Knm9HESSiDT7lXtMl2hMnQRWzR
 uJQ.A4k8mBONDQB.zwHTAnq8ilJ2w0bczV_SDZ3BO_Fa23gqAueio56VRhxp4PRlMc9GdIQTUKXQ
 w7HDgaTIs5XvyJQvYtMirU9v2syYVgTqcr6OF3vAvDZMHeIXvY44MtE2ZNwcjO7.xDPRs6AQHJMG
 CUdHGDVEfHZ0V5MH756k79pnO1.Pa6KvqgfEXtzvvufNz3RUYFzoZlrWaXw_uMIRZUrY8CgvuaU4
 FNPxDZN7HGpB7dMRlZfHF9RgizzsjCphwAgNgw7OvcnYuLlGnD9YdDDjhq0qV2zid1kYBiR.vbw1
 sv9.0PmrmMouehiz7iu_lX0kkSO7WYvK6fYLX0fxvhIJRzuh8vt0_Yc0UuVRzjUg7R0ERsd3Cbuf
 rXxxjSl_9CoMG0hHAxN285RwnrlNQH4zBTNlA3fkvMQvnMmcSRCAaZsuorkpstcG3hByL4GIA1Zd
 ._NlZgZe5M2Miagy8qQGd.CnhJO93xxffdx3FbnFXoPf23ELy3QOW06fuz6bMivH7a8PB6MG0rll
 vWIAB6Kk9okAbY9LgHWqlhqjGH3kSVRuUPrE4s65G8EXkLsbU.3VMKVymOPp7Rap4mW0HUCI9g87
 wIigcIvmt79CnYGi2pH574id3jhSk9qReau_f.vqV7Ne0BGOctsxKeTZVZQV_dloEAdho80zeg92
 AClgzRwTm2Efg9TjSG6SZH263RxmA5MK2GTnXgX7d77pHiM5MaJzamYqECtXpCSvkAkTdKtHrNZL
 V8rM6QhdGWeZbavhwkJYpgfLR6rdHUuoquf.zaYeYIJPwkjEpZAi6ACbeFim84ZpE_GezdQOrgkq
 Ccmr52wyc_35zvw5sAGmtInxoZxDdCyNx0.AtUTyo2PyHsqsf0HLUFC3D_Tfrp39nbA7bECiu5QN
 wFgq8ZIkXsBDpiEpHe73KL7RVauYlnq6bvU_o77l5okLwrkUnL8Zu83aWhkP5wPUENxuIYyqgTqO
 64_Rj_CRpw4m9xIZQ_dzFtipm6jqjeyUrtZexGqCQgcOgNuZXwZ6VJUyhR6HFijvYXbRHrAOas.x
 t3qiemZDdamQHd.B92X635Zfd3Rqab7K8xjVf_yyU_Em9EA2HQMAu.5cS_tmyiVUjRdlRS7SW
X-Sonic-MF: <pjp@fedoraproject.org>
X-Sonic-ID: f1914840-01ca-47ad-9f32-d32a8639d281
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.sg3.yahoo.com with HTTP; Mon, 8 Apr 2024 05:23:38 +0000
Date: Mon, 8 Apr 2024 05:23:32 +0000 (UTC)
From: Prasad Pandit <pjp@fedoraproject.org>
Reply-To: Prasad Pandit <pj.pandit@yahoo.in>
To: Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, 
	"Shivasharan S." <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Message-ID: <961050424.4042540.1712553812936@mail.yahoo.com>
In-Reply-To: <1265686183.1518841.1711608367704@mail.yahoo.com>
References: <20240311121127.1281159-1-ppandit@redhat.com> <1981046737.3660465.1710764698242@mail.yahoo.com> <1265686183.1518841.1711608367704@mail.yahoo.com>
Subject: Re: [PATCH v1] scsi: megaraid: indent Kconfig option help text
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22205 YMailNorrin

>>On Thursday, 28 March, 2024 at 12:16:07 pm IST, Prasad Pandit wrote:
>>>On Monday, 18 March, 2024 at 05:54:58 pm IST, Prasad Pandit wrote:=C2=A0
>>>From: Prasad Pandit <pjp@fedoraproject.org>
>>>Fix indentation of megaraid options help text by adding
>>>leading spaces. Generally help text is indented by couple
>>>of spaces more beyond the leading tab <\t> character.
>>
>>Ping..!
>
>Ping...!

->=C2=A0https://lore.kernel.org/linux-scsi/1981046737.3660465.1710764698242=
@mail.yahoo.com/T/#t

Ping...!(just checking)
---
=C2=A0 - Prasad
