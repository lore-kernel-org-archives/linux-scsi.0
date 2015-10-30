From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RESEND PATCH v3] scsi: stex: Remove use of struct timeval
Date: Fri, 30 Oct 2015 09:50:00 +0100
Message-ID: <1446195000.16404.55.camel@suse.de>
References: <20151030083040.GA31741@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbbJ3IuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 04:50:02 -0400
In-Reply-To: <20151030083040.GA31741@tina-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org, arnd@arndb.de
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, y2038@lists.linaro.org, linux-kernel@vger.kernel.org

Hi,

On Fri, 2015-10-30 at 01:30 -0700, Tina Ruchandani wrote:
> Function stex_gettime uses 'struct timeval' whose tv_sec value
> will overflow on 32-bit systems in year 2038 and beyond. This patch
> replaces the use of struct timeval and do_gettimeofday with
> ktime_get_real_seconds, which returns a 64-bit seconds value.

Thanks for the conversion. Can you please check if other (scsi) drivers
have the same y2038 issues? A quick "git grep do_gettimeofday
drivers/scsi/=C2=A0=C2=A0| wc -l" reveals 30 occurrences (of cause not =
all are
problematic).


Other than that
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
