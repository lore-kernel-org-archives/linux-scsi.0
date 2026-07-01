Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA6E481AA0;
	Wed,  1 Jul 2026 12:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910668; cv=none; b=a5AC093Rewh3vqcTbhL2Dkcvu4fak6EFZUH0y+kk+ctUBCnUEydxnfcJSJ7Stjf3FyFRnQPdBq8RmLEW6Oc1ICSHhRWjJ3Dvu3dKTZeiMDGpgW79ibADosgCJgTXir+32NORfi6Cpy5G3S6bqT/LAfA2dI95+J5EKDZnDxKXH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910668; c=relaxed/simple;
	bh=zkYhl3CtbmJbats+wc7zDUgYg3p4SDBgKRAXiMc3XmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sAsNwjeekkO0m7607RSc6KKfIvEeHLAI41C8LDvyxrXnUBy3K/ubweXeSrjaGccT8jQPBzELsON+Eds2al9SEPomJRD4XZvvfzUHl57lpBBTFx/oiWN8xErx7JeAKPOa/PeCta/Fns9w8WnAZml0OnRrHbt0jTyDw1pvCSsUwAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 658361C62DE;
	Wed,  1 Jul 2026 12:57:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 322E920025;
	Wed,  1 Jul 2026 12:57:39 +0000 (UTC)
Date: Wed, 1 Jul 2026 08:57:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Peter Wang (=?UTF-8?B?546L5L+h5Y+L?=)" <peter.wang@mediatek.com>
Cc: "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, "CC Chou (=?UTF-8?B?5ZGo5b+X5p2w?=)"
 <cc.chou@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>, "Chaotian Jing (=?UTF-8?B?5LqV5pyd?=
 =?UTF-8?B?5aSp?=)" <Chaotian.Jing@mediatek.com>, "Eddie Huang (
 =?UTF-8?B?6buD5pm65YKR?=)" <eddie.huang@mediatek.com>, "Qilin Tan (
 =?UTF-8?B?6LCt6bqS6bqf?=)" <Qilin.Tan@mediatek.com>, "Lin Gui (
 =?UTF-8?B?5qGC5p6X?=)" <Lin.Gui@mediatek.com>, "Yi-fan Peng (
 =?UTF-8?B?5b2t576/5Yeh?=)" <Yi-fan.Peng@mediatek.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "Jiajie Hao (
 =?UTF-8?B?6YOd5Yqg6IqC?=)" <jiajie.hao@mediatek.com>, "Naomi Chu (
 =?UTF-8?B?5pyx6Kmg55Sw?=)" <Naomi.Chu@mediatek.com>, "Alice Chao (
 =?UTF-8?B?6LaZ54+u5Z2H?=)" <Alice.Chao@mediatek.com>, "Ed Tsai (
 =?UTF-8?B?6JSh5a6X6LuS?=)" <Ed.Tsai@mediatek.com>, wsd_upstream
 <wsd_upstream@mediatek.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "Chun-Hung Wu (
 =?UTF-8?B?5ber6ae/5a6P?=)" <Chun-hung.Wu@mediatek.com>, "Tun-yu Yu (
 =?UTF-8?B?5ri45pWm6IG/?=)" <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
Message-ID: <20260701085740.218cf4d9@gandalf.local.home>
In-Reply-To: <e4c090a5b8402fe3db137d986f9a6639de73cc67.camel@mediatek.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
	<20260630165612.3e21b510@gandalf.local.home>
	<20260630174949.16a9d867@gandalf.local.home>
	<e4c090a5b8402fe3db137d986f9a6639de73cc67.camel@mediatek.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 322E920025
X-Stat-Signature: x4gaju9sut5o7zrucc5oguhexokm5rdk
X-Rspamd-Server: rspamout04
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/xreLa1BHmWb4rHSrAqeiMAemv580Qk8c=
X-HE-Tag: 1782910659-907956
X-HE-Meta: U2FsdGVkX18uy8au4Rgvq2R6ekNAy0sdc9mHg58V3h96aUiu9oQdJ2/1GCr5+z2r+5PpfLpBlBg7IRhUbQeou81TUk42Azl+X2S+Hkty9dWbxZJXyy6N8NggGIn1XLp2xLKWAPQRdrLL4upLNH/ViBJAAHDaNf1Q4Hd47iTapNl7J5CSubOReveK35FqfMZ0OBcViFip23edw6/DjxOR40ny15SkTkLs2pyFRbhRaogeSMlRypQQ7R2j+1RmrMgbCNMmx1cnUoE0wR+6+2JrXLjTcnAf0XpQEy96PopahgsYq/La/2evA5+vZhEEg6fCPQuAHoGW65zPW+4tnIianQzwFA+ax4sQ

On Wed, 1 Jul 2026 06:11:37 +0000
Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) <peter.wang@mediatek.com> wrote:
=20
> However, I am curious: if the HBA is removed, implying that the=20
> storage would become unusable, might the system encounter an=20
> I/O hang or shutdown, potentially preventing its detection?=20
> Perhaps it's a theoretical issue that would not manifest=20
> in a real-world situation?

Note, it doesn't necessarily mean that the device itself was removed. The
issue is that a pointer to an allocated descriptor is saved in the ring buf=
fer.

Maybe once the device is created it will never go way. But what happens if
for some reason the descriptor is freed and reallocated? Now the old
descriptor pointer is still in the ring buffer.

What in the logic guarantees that the pointer will never be freed?

And lets say there is an issue and the hba is freed and you debug this by
dumping the trace buffer via ftrace_dump_on_oops. Now the dump itself may
crash and you don't have a way to debug what happened.

One other point that causes issues here. It makes user space tracing
useless. Try tracing this with "trace-cmd record". These events will not be
able to be parsed.

-- Steve

