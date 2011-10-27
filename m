From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] scsi_dh: check queuedata pointer before	proceeding
 further
Date: Thu, 27 Oct 2011 08:25:42 +0200
Message-ID: <4EA8F966.6050008@suse.de>
References: <47D23AD8469A2B448F33C24BD7A39BD91040F25B@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1J0GVQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 02:21:16 -0400
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD91040F25B@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

On 10/26/2011 08:29 PM, Moger, Babu wrote:
> This patch validates sdev pointer in scsi_dh_activate before proceedi=
ng further.
>=20
> Without this check we might see the panic as below. I have seen this
> panic multiple times..
>=20
> Call trace:
>=20
>  #0 [ffff88007d647b50] machine_kexec at ffffffff81020902
>  #1 [ffff88007d647ba0] crash_kexec at ffffffff810875b0
>  #2 [ffff88007d647c70] oops_end at ffffffff8139c650
>  #3 [ffff88007d647c90] __bad_area_nosemaphore at ffffffff8102dd15
>  #4 [ffff88007d647d50] page_fault at ffffffff8139b8cf
>     [exception RIP: scsi_dh_activate+0x82]
>     RIP: ffffffffa0041922  RSP: ffff88007d647e00  RFLAGS: 00010046
>     RAX: 0000000000000000  RBX: 0000000000000000  RCX: 00000000000093=
c5
>     RDX: 00000000000093c5  RSI: ffffffffa02e6640  RDI: ffff88007cc889=
88
>     RBP: 000000000000000f   R8: ffff88007d646000   R9: 00000000000000=
00
>     R10: ffff880082293790  R11: 00000000ffffffff  R12: ffff88007cc889=
88
>     R13: 0000000000000000  R14: 0000000000000286  R15: ffff880037b845=
e0
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
>  #5 [ffff88007d647e38] run_workqueue at ffffffff81060268
>  #6 [ffff88007d647e78] worker_thread at ffffffff81060386
>  #7 [ffff88007d647ee8] kthread at ffffffff81064436
>  #8 [ffff88007d647f48] kernel_thread at ffffffff81003fba
>=20
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke              zSeries & Storage
hare@suse.de                  +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
