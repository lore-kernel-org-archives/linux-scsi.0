Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A03385519;
	Mon, 13 Jul 2026 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783952002; cv=none; b=ZV2UVUylNdmydDmzAVnVoaqLEHeYJ02UhrN+EmLY3D/iNPtfGiHHJeFaFvejmIRr2AdUbAZvq/fw/WBnKJ/M6J2a02n3zDAVGglFENS783Ag674cnrO5rmEla14h6Ot8wP7PzseKDSrViWl666vLbbjWSP+BZgLcMVIJJmmTfb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783952002; c=relaxed/simple;
	bh=lib18pazABsdijxIBd7WveIiQ+XyAsidTkjWFpcROVI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGS16r2X/oiLq23eV/AEc423ntJiPiY7Aym0Oxjn7S0fAyQu08ToUY0S7lTbd7ijF95Qg4HgiRqNZX1KJpPRm7DfLgUstvS+Nd0uWCPp+EMNOFZ3PTbFwNfkC8+sEX0z7n4soKltab1Z0jGvZTkSXmxX9UrMmv0569U7gYJly4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 770B9C06EB;
	Mon, 13 Jul 2026 14:13:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 280B76000B;
	Mon, 13 Jul 2026 14:13:10 +0000 (UTC)
Date: Mon, 13 Jul 2026 10:13:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche
 <bvanassche@acm.org>, James Bottomley
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>
Subject: Re: [PATCH] ufs: core: tracing: Do not dereference pointers in
 TP_printk()
Message-ID: <20260713101310.401cf2d4@gandalf.local.home>
In-Reply-To: <178390967056.3399387.17096580780727607387.b4-ty@oracle.com>
References: <20260630185412.283c26c5@gandalf.local.home>
	<178390967056.3399387.17096580780727607387.b4-ty@oracle.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 280B76000B
X-Stat-Signature: cozybrjgfj3fgpewpfhzajstfb9wy9fn
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19YlkfupV30pHmsLUYQiehsMv2buMygz6k=
X-HE-Tag: 1783951990-167658
X-HE-Meta: U2FsdGVkX1+mO9Byn01FWJyP8TvIssSdm4c+/RQa7XOyEBYZNJuM1I0QIxKC1Nm7wex1ytBfgd4+wust6Lw07rqmkojeoOsp6p8GeAzxGgFWhay/2ON0xlDkm0uM8Et9RuM+Cr1NJKsXDqcaO83VotHCYoMJJ7srG3jEGbbtckZh8xcOtQPmcxSVBHUUHZKz7L8TFtYruSpfgv0ZlTuoltsYxSC97qsup/4TKYC9ZCGuT+O+oKSTKc2tZtyUoPgbuW2LNs5FK+gqZh67H+YUCFC20GM7K593j88qW5YyZkciYPVEKYKvleAWMOzkCMFj8kNvCJTUJHvOswypnoaJQ7yrX9xjav9vUvhclRDoxjWgJ/vhFjw06aqXCKSgOgjvod4EerUw6lo=

On Sun, 12 Jul 2026 22:32:37 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> Applied to 7.2/scsi-fixes, thanks!
> 
> [1/1] ufs: core: tracing: Do not dereference pointers in TP_printk()
>       https://git.kernel.org/mkp/scsi/c/46aea2c64e11

Ah, I should have waited for you. I had the reviewed by from Peter and
Bart, and thought they were the maintainers of the code so I pushed it to
Linus already.

I see now they are listed as reviewers. Sorry about that.

-- Steve
