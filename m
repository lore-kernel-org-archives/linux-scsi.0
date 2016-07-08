From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid_sas: Do not fire MR_DCMD_PD_LIST_QUERY to
 controllers which do not support it
Date: Fri, 8 Jul 2016 15:01:45 +0200
Message-ID: <9989ca77-56cb-7ac4-5947-f979218c2f97@redhat.com>
References: <1467973816-17448-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1467973816-17448-1-git-send-email-sumit.saxena@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com, lucz@geza.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8.7.2016 12:30, Sumit Saxena wrote:
> There was an issue reported by Lucz Geza on Dell Perc 6i. As per issu=
e reported,
> megaraid_sas driver goes into an infinite error reporting loop as soo=
n as there is a change
> in the status of one of the arrays (degrade, resync online etc =E2=80=
=A6).
> Below are the error logs reported continuously-=20
>
> Jun 25 08:49:30 ns8 kernel: [  757.757017] megaraid_sas 0000:02:00.0:=
 DCMD failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.778017] megaraid_sas 0000:02:00.0:=
 DCMD failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.799017] megaraid_sas 0000:02:00.0:=
 DCMD failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.820018] megaraid_sas 0000:02:00.0:=
 DCMD failed/not supported by firmware: megasas_get_pd_list 4115
> Jun 25 08:49:30 ns8 kernel: [  757.841018] megaraid_sas 0000:02:00.0:=
 DCMD failed/not supported by firmware: megasas_get_pd_list 4115
>
> This issue is very much specific to controllers which do not support =
DCMD- MR_DCMD_PD_LIST_QUERY.
> In case of any hotplugging/rescanning of drives, AEN thread will be s=
cheduled by driver and fire
> DCMD- MR_DCMD_PD_LIST_QUERY and if this DCMD is failed then driver wi=
ll fail this event processing
> and will not go ahead for further events. This will cause infinite lo=
op of same event getting
> retried infinitely and causing above mentioned logs.
>
> Fix for this problem is: not to fire DCMD MR_DCMD_PD_LIST_QUERY for c=
ontrollers which do not
> support it and send DCMD SUCCESS status to AEN function so that it ca=
n go ahead with other event
> processing.
>
> Reported-by: Lucz Geza <geza@lucz.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

This makes the functionality another bit closer to what we had
before 'megaraid_sas: MFI IO timeout handling'.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
