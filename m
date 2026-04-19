Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CD637BE62
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2026 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776604458; cv=pass; b=b2eICvl5b29NHgTqn8S9ml2mhTfTfqqVSoS6gwObtCvXeRtRM4hPqzuhQsvHvqtXx8qi0xBRbyoEdAJeKwOS6mJxLohktz8sbh9k4aMYqkIXAli9YbVn4E/CvmypGAdvatZIzpTHGB+WE8ODK1TQ4CRWnSGAlgLM/mj2vjIKYr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776604458; c=relaxed/simple;
	bh=qe/8/rd6eZq24hJL9eY4fBiSEHVVKDLumzkH60jo5p0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jEbnNLW3XV+buhf7uxXRXkMfEmrtxOmPrD5Zm8M7pzveYAmQJRd/PItEr/ABi6JQdJdWC57uMsTdIKT4LoyqkbcVTPouxxlCkMJFreKHJFcQ6QuCjv6QwKGFOEvp+rFZ+2s1j3bl4mlmy5zve3TQq+7pvAQ9v6oH4vdNTguiPIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=RF+j7+hH; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="RF+j7+hH"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651b0eb2564so2193172d50.3
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2026 06:14:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776604455; cv=none;
        d=google.com; s=arc-20240605;
        b=ef0nBSADhs0Dw6vbrdC3NatXBJ9PG/dTZiL0k9zW+jfud9R8v2W09If09rXQ0gaufF
         OYqk02lFFLFdYbLyWfuq+4da5f7f1a+aR29TX1vtUqS5hjS7pWE/4V4nLDFo+JbaOz1f
         5cEeEvhn95VQGemh/6cSvxzW6F/5dBPSaLK7qESoAjPXkCzeu9+VmtlTPBl/sZIAORA1
         oJCSM0Pu6N6nizGhTKifLELBTqIISp/6vl6X8LOs6V8eTEJsNtxSisI076dy3LpOaQEU
         w3xUUFiPyBMGmQ9yq2BE/V/6skBp8FnGdYZpsuWTwKswXKedoN228EtJgSFq3p/pd+pH
         BhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        fh=bPFP65UIzCfKXFPi4LlqUMJZwHbLF89EGbI78d/R5Io=;
        b=ScEaNcXHVx9gj/NA6nNTlc3f++FgRBShMGavgeZW3fDwiznuvQguOGs0fM+EHzENOU
         /wEsiLPEs6bJ5rZWS6ZgmC/HJAySkX/mgyuKhh5qYbXomYIhcay3WAphpB5jlT/u2wkh
         Di8A8bGEaR82fCmVh/QmO75f8yUBUWXMEJeVxju3Zitg/qNn21cwJs7+mykjDuoYniTx
         EY190sdcCy1B9QIyDS/Mt3RP4Uvq1mze933L07pB6bfsmEJrg4SR0SFjRppzWIRQ8m2y
         e9Ygm7k5uyNUzErsYK5zYgMbIq/iXOrS/CnSqRGAo0TPCmOGgPXcnFEKKxTnGDsRIQ6O
         8eyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1776604455; x=1777209255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        b=RF+j7+hHVxK6KZm7vPd2VqoOm/wjdXQLWhOzfortaWaPcUVwcAQrCs3L0CFMuiRg7q
         QnfAqyyLg1KJ+FRhOaVPXbDj/1oQAlKqMc8aZVWWLmxNSIvN0DqnMlIAoJn6kuX0b/7J
         7sPHT3tJByJtn837fhiWKur8kP67w4ITGeKuH61ShAM9KSbiPZhuqcwRf0AI+YYvfUzE
         nm7TFbEi+qyg5VUzXDZfGrK2suVGd+PyZxZUbRBAHRptfz+N0eKCGeaG7itaOxMnDo4a
         9pQYTEUA6X1M/ONh/tBNfIzrR7/o898AAKuwOGzc6VJY9VVEJ/2rd2ZdsoDfuP51zO2Z
         aU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776604455; x=1777209255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+WVMuAIY6fuTgPsvbyDiChtmsWhcTJteNRfYOEl4tw=;
        b=XHXhmkxIcbWzgpwJXQ0cpK88RaIaytAx0tbiHreZzsUWJIuJzQqoHZsJIHwXTZzyRA
         I9/SMPgST4g15Fy/sPf82zkPH+fy09TQ8pOMRhmxaybaclT2N5Dg6GBenKby9oK90Hnr
         Zab9p05SCsaPivuDdfhjDneb+U0LG+mBZCkAVC40V05FiC0sp5tyLGUHRC6s8S28VGq2
         XceIv8RuO0vmUyGo6cQVz7HjEF/R8Buu91QLT71m1e0AdI5QgywTv1WrxrIcwGu1++eu
         e6x/569W+aMBTBExe5LWUnHFrXNbP68h5gcYOQn2ukhZ9JNKS1aeqwFHuuT74tJ0MJR4
         Lmxg==
X-Forwarded-Encrypted: i=1; AFNElJ/fbcFPiFgERUHHA6KuDBV5S2b31bvb9Wqn2hoinnpNYD/ICFORPfAa9CxeuX3MB7NHypO6DOiNSozm@vger.kernel.org
X-Gm-Message-State: AOJu0YxiqJZWrUtIhyhN5cmR7QDT0DK7PDwdyorTYZuM8vNQBepOxLAp
	skHRJpXVb+JQ+EeqrVkUY52OMNzl6XVMbvrJh92FvZOUhFghjenJ0HAXUcjIrcIOga67jQYGuzV
	9mhkWsGDF4I4VwSvLJoozEKGUeYP8i60atLXhHxQq6g==
X-Gm-Gg: AeBDiesosmCbtI/lB2erFJDnIagAc+EDQ2mMRzQG3+++MtcA44zfoSJWmsQdOb3Tpts
	2UOd3Vui9kauTiOcSZFFGfEFku1J20cqdNjHw4r0xD900I5suOrs0Nj6sZ/I/veXYLCGdCVzoJj
	Dej/TVSbw4d/m/vODt+hWjWnigq6OLCoykkbGYoU41OhJaO/9Kvb+F1rKC2jAsqP7nueyxUKjiA
	wKbr+LKjCQxntkiYaYZ9PONqgERqAmCgwyPXS6OiDHWjUvMe8o1VNqXf86c6gTl30PhWR0R1UZG
	/5djxBEOX6qAv1iJIg5z7j3hiOth
X-Received: by 2002:a05:690e:4811:b0:651:bcc9:50cd with SMTP id
 956f58d0204a3-653107ccddamr6102177d50.5.1776604455299; Sun, 19 Apr 2026
 06:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323160052.17528-1-vineeth@bitbyteword.org> <20260418190456.631df6f3@fedora>
In-Reply-To: <20260418190456.631df6f3@fedora>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Sun, 19 Apr 2026 09:14:04 -0400
X-Gm-Features: AQROBzCejbUFLEO14GEr24qqxXnlBQ97NPzS668jjkdcYvI-3kvv1xuemSCQk44
Message-ID: <CAO7JXPh+__EWsW8fsKi4T+w0jdPxZEfCLQno_ukJk2=d2s0WKA@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] tracepoint: Avoid double static_branch
 evaluation at guarded call sites
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>, 
	Aaron Conole <aconole@redhat.com>, Eelco Chaudron <echaudro@redhat.com>, 
	Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	linux-sctp@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	dev@openvswitch.org, Jiri Pirko <jiri@resnulli.us>, Oded Gabbay <ogabbay@kernel.org>, 
	Koby Elbaz <koby.elbaz@intel.com>, dri-devel@lists.freedesktop.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Huang Rui <ray.huang@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, 
	MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, 
	Chanwoo Choi <cw00.choi@samsung.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org, 
	Eddie James <eajames@linux.ibm.com>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Joel Stanley <joel@jms.id.au>, linux-fsi@lists.ozlabs.org, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Deucher <alexander.deucher@amd.com>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Philipp Stanner <phasta@kernel.org>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
	Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org, 
	Mark Brown <broonie@kernel.org>, Michael Hennerich <michael.hennerich@analog.com>, 
	=?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, 
	SeongJae Park <sj@kernel.org>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 7:05=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 23 Mar 2026 12:00:19 -0400
> "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
>
> >   if (trace_foo_enabled() && cond)
> >       trace_call__foo(args);   /* calls __do_trace_foo() directly */
>
> Hi Vineeth,
>
> Could you rebase this series on top of 7.1-rc1 when it comes out?
> Several of these patches were accepted already. Obviously drop those.
> They were the patches that added the feature, and any where the
> maintainer acked the patch.
>
> Now that the feature has been accepted, if you post the patch series
> again after 7.1-rc1 with all the patches that haven't been accepted
> yet, then the maintainers can simply take them directly. As the feature
> is now accepted, there's no dependency on it, and they don't need to go
> through the tracing tree.
>
Sure, will do. Thanks for merging this feature.

Thanks,
Vineeth
