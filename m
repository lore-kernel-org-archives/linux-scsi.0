From: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH 3/3] st.ko: change enlarge_buffer result
Date: Mon, 16 Dec 2013 20:48:32 +0200
Message-ID: <E0B3592D-FAC1-4830-AFC3-9643F27CA9DF@kolumbus.fi>
References: <61eb00$4eu08n@dgate20u.abg.fsc.net>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:41948 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3LPSsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 13:48:36 -0500
In-Reply-To: <61eb00$4eu08n@dgate20u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org


On 2.12.2013, at 21.00, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:

> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Date: Mon, 2 Dec 2013 18:52:10 +0100
> Subject: [PATCH 3/3] st.ko: change enlarge_buffer result
> 
> enlarge_buffer() just returns 1 or 0 if it could or could
> not allocate the requested buffer.
> 
> In case of result 0, the callers always set the error to
> EOVERFLOW. I think, this is not a good errno for those
> cases, where enlarge_buffer() could not allocate the pages
> it needed.
> 
> So I changed enlarge_buffer() to return a meaningful
> result (-ENOMEM or -EOVERFLOW in case of error, 0 in case of
> success) and the callers to use this result.
> 
ENOMEM is used for telling the user that, in variable block mode, the byte count in read() is smaller than the next block. This may not sound like proper use of this code but this is how the tape drivers have done. When ENOMEM is not used, the patch would be only cosmetic.

Thanks,
Kai

