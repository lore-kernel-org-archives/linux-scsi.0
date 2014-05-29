From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Convert to percpu_ida session tag
 pre-allocation
Date: Thu, 29 May 2014 20:29:34 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46D0994E@avmb2.qlogic.org>
References: <1400892216-9784-1-git-send-email-nab@daterainc.com>
 <1400898802.6476.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46D0994Eavmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:56017 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932342AbaE2U3g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2014 16:29:36 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s4TKJ9cA021555
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 13:29:36 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1m1snxjmm4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 13:29:35 -0700
In-Reply-To: <1400898802.6476.25.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D0994Eavmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D271300C1F0DA845A1A06C62BC53DA6A@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Nicholas,

Answer is below.

Regards,
Quinn Tran




On 5/23/14 7:33 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Qlogic folks,
>
>A question for you below..
>
>On Sat, 2014-05-24 at 00:43 +0000, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> This patch converts qla2xxx target code to use generic percpu_ida
>> tag allocation provided by target-core, thus removing the original
>> kmem_cache_zalloc() for each struct qla_tgt_cmd descriptor in the
>> incoming ATIO packet fast-path.
>>
>> This includes the conversion of qlt_handle_cmd_for_atio() to perform
>> qla_tgt_sess lookup before dispatching a command descriptor into
>> qla_tgt_wq process context, along with handling the case where no
>> active session exists, and subsequently kicking off a seperate
>> process context for qlt_create_sess_from_atio() to create a new one.
>>
>> It also includes moving tag allocation into generic code within
>> qlt_get_tag(), so that the same logic can be shared between
>> qlt_handle_cmd_for_atio() + qlt_create_sess_from_atio() contexts.
>> Also, __qlt_do_work() has been made generic between both normal
>> process context in qlt_do_work() + qlt_create_sess_from_atio().
>>
>> Next, update qlt_free_cmd() to release the percpu-ida tags, and
>> drop the now-unused global qla_tgt_cmd_cachep.
>>
>> Finally in tcm_qla2xxx code, tcm_qla2xxx_check_initiator_node_acl()
>> has been updated to use transport_init_session_tags() along with a
>> hardcoded TCM_QLA2XXX_DEFAULT_TAGS=3D512 as the number of qla_tgt_cmd
>> descriptors to pre-allocate per qla_tgt_sess instance.
>>
>> Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>> Cc: Quinn Tran <quinn.tran@qlogic.com>
>> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
>> Cc: Roland Dreier <roland@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>> ---
>>  drivers/scsi/qla2xxx/qla_target.c  |  195
>>++++++++++++++++++++++++------------
>>  drivers/scsi/qla2xxx/qla_target.h  |    6 ++
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 +-
>>  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 +
>>  4 files changed, 142 insertions(+), 65 deletions(-)
>>
>
><SNIP>
>
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> index 68fb66f..34db344 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>> @@ -1482,7 +1482,9 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>>      }
>>      se_tpg =3D &tpg->se_tpg;
>>
>> -    se_sess =3D transport_init_session(TARGET_PROT_NORMAL);
>> +    se_sess =3D transport_init_session_tags(TCM_QLA2XXX_DEFAULT_TAGS,
>> +                                          sizeof(struct qla_tgt_cmd),
>> +                                          TARGET_PROT_NORMAL);
>>      if (IS_ERR(se_sess)) {
>>              pr_err("Unable to initialize struct se_session\n");
>>              return PTR_ERR(se_sess);
>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>>b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>> index 33aaac8..b0a3ea5 100644
>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
>> @@ -4,6 +4,8 @@
>>  #define TCM_QLA2XXX_VERSION "v0.1"
>>  /* length of ASCII WWPNs including pad */
>>  #define TCM_QLA2XXX_NAMELEN 32
>> +/* Number of pre-allocated per-session tags */
>> +#define TCM_QLA2XXX_DEFAULT_TAGS 512
>>
>
>So a question wrt to the TCM_QLA2XXX_DEFAULT_TAGS value above used to
>determine the number of qla_tgt_cmd descriptors to pre-allocate at
>qla_tgt_sess creation time..
>
>This value needs to line up with the total number of possible incoming
>ATIO packets, plus the number of qla_tgt_cmd descriptors that have not
>been acknowledged with a CTIO packet.  Typically with other fabrics that
>have been converted to use percpu_ida, we over-allocate the number of
>per-session tags in order to completely avoid the slow-path where
>percpu_ida has to steal tags from another CPU.
>
>AFAICT, there is no way at the qla_target driver level to enforce
>per-session queue_depth + reflect the depth at the initiator port, so
>the number of tags needs to be the worst case number of HW descriptors
>that a single session can consume + number of unacknowledged
>descriptors.

QT> QLA driver & FW currently do not have queue_depth control at a per
session level. Instead, the descriptor pool (i.e. Exchange pool) is manage
by FW at the Port level.

>
>So the question is, is there already a define somewhere in qla2xxx code
>that TCM_QLA2XXX_DEFAULT_TAGS can use as a starting point..?  If not,
>what is the total number of outstanding commands that a single session
>(or single port..?) can expect to handle at a given time..?

QT> Typically, the worst case value we see is 2048 for each port.  It's
currently not #define.  This value can change over time.  A good starting
default value for TCM_QLA2XXX_DEFAULT_TAGS would be 2048 + %2 pad =3D 2088.

Extra size note, the true value should be extracted from
"ha->fw_xcb_count", if this field is set.  Otherwise, default back to
TCM_QLA2XXX_DEFAULT_TAGS.

>
>--nab
>


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D0994Eavmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IoFQAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAENENkFGRTNE
ODRFRjU5NENBREM1QUZBODFDM0EzMzBEAJsHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBQAdABQA
HQAiAAQAXgEBIIADAA4AAADeBwUAHQAUAB0AIgAEAF4BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAEYAAABSZTogW1BBVENIXSBxbGEyeHh4OiBDb252ZXJ0IHRvIHBlcmNw
dV9pZGEgc2Vzc2lvbiB0YWcgcHJlLWFsbG9jYXRpb24A5RgBA5AGACgZAAA1AAAAAgF/AAEAAAA8
AAAAPDUwNEVCNjZEQUM4RDIzNEVCOEU4NTYwOTg1QzJEN0FENDZEMDk5NEVAYXZtYjIucWxvZ2lj
Lm9yZz4ACwAfDgEAAAACAQkQAQAAANUMAADRDAAAMRoAAExaRnVWfMfvYQAKZmJpZAQAAGNjwHBn
MTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQwIO8HbQKDAFARTTIKgAa0AoCWfQqACMg7CWIx
OQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5QA2Bzom8BgCBFeBHBbhgwXQZSdgSQF7YCEHIA
wHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ5HdrC4BkNR1TBPAHQA0XcDAKcRfyYmttawZz
AZAAICBCTV9C4EVHSU59CvwB8QvxCwewDlBoBvBhcyxcWmwLgGUKgSJEQQCAdyMbsQQAIGJlCQB3
LjEiPFJlZwsRIhdRdfsLgAOgVBhwC5AiSyb/ImICTwOgNS8yMy8xADQgNzozMyBQEE0sICIhpiBB
Lg8fsCPAIkEYMHIiIDyKbgGgQCJBdXgtBAAKYwCQLgWwZz4gdwsDYBAgOiI8PkhpIPpRCQBnDlAc
cAbwH1AiJmI+LaZBIHEKUB9gafcCIC6xBcB5CGAjpSQGL5c7KLEGEHQp0AHQKTAtMFg1LTIpQBiA
IB6gOvo0KZArHqAeoCnQKg8rEtUszD4ssEYDYTo06DW4zyt/LII2tza4VGgjgQqwLnQRwBvWBCBx
C2AyeP884BzACsAYMAVABaABABzAaG8gdRIAIBgzLpFw0wSQDmB1Xw3QYTa4AZC2ZzPgKuBvHlAw
g3ADYKcdYAEAHGBieT0VLQWh0mUp0HRoPhAgCXAEYN8dYBnAQoEZ4AWwaS6AOPBvCVA2xx8wQvBf
HlARwGWkX3pAUygpMMNlRTFiIB9gcnVjBUA8oV/odGd0RRBtHGABAAT0vwWxC4BDYja4C4AFoG1D
MpBBVElPO6Fjaz1h7mYiAEIQO7FoMbc6vkmB/wpAR9FDYxvkAJAwoRkwPJFbR3AZoWQecEeCXxrh
X/9AokXhPeE+0RriNrhHFhIAwwQRCQBva3VwI6Ea4a8Z4A3hO7NDMmEb0W0DgUdHvRiQUO9fd3FA
8mP/UhIb4RAiKdAHQAIgQDAD8L1CkCBO40M2HlA+IXdDgP1TAW5VeQDQMIAaMEaQUhE/MJIQMAQA
PHBXwVRhc3XuYhIAMEECMGxBoB2gSoD/QzIZME6AU/ASAD7RGIBI2f9W3TDDTqIFAEZQECBR80+A
fwNhT8lg1FPhGFAH4AIgZftLbzchSQVAB0AZIEzoQwb/QCxVQj5HPZNYQguBVZlHcP89UUdAQCBF
4CnQZRFCkDPx+UNyc2EHgFJBLoIeUAOg/yOwRpAR0UFiEhAjQAnwaLy7Tu9P8ytgj2GaV1VzY4gn
KoBlASnQX19tomRv+1aQBbBrReER0COSCfBlwP5hPbE+VmyVI6As8DvwWhD/GwFEKV9eSIFy3G9P
YYpjj/83IQfAV6JSkD9QYsFtogNQ/wngR4JQFAlwHnBZckNyPtTfLBA/UEACXBQ2uGQDYFKg40Ny
WhB3LXUr4BIAHGC6ZwkAYgdARwpFFHB6z/83IkPyXSFIgkeQcsE8xD2S/0JxhWhFEEOASoA/MAMA
MID9GIJfWhABAE/ATRBF4Da4v3O3fGQcYD3lRrAAcXAJEe+Hg1HzMJFpwnNF4VfpP2lNEdFkPZIc
YFRDH9BREExBMliPUF9ERQBGQVVMVF9UQfBHUz01DpAz4E1kK+D/BtAbsU5zRzd/+UfnTWFQUf0J
cC1AVX6TUXwLgB9hSZBzY383EkNjN5AGEAhwYYh2IEsiAGh5YVKgpjxrAJfyLmuYVEA8oP0uci5J
oZbtJeg40DBAJgFOLorymb+XR0dpBRBkvxHRBdAHQJgQB0AuMDwugL2edC52EZ8TnL+XR0MR0F0c
YERSkCXwBCA8EcFk/C5kopOgn5dHCAALYFRhvkQJcAiRONADYKVyQEqQ/wSgI8A57KHlBRAfYICw
O/DOSCrRA/BAMDxoEcA5IGsfYKNAZTq5U0PQGFBkei1d0S1BkDefOK85vyC+La7QNriAgVsBEfAv
LDJ+LzylsHJpwT1CpCCvkHzvr5AWcB3gNsYrst+zRK7Rf7RXrw+wH7EnO/Cx0rWgNv00cCu1H7Yt
hVmxobfzKUD/tEC4j7mfuqg78LfzkIC4et0pQGYDEAeRGZRkKdApMF+QgJXRG4EwkYyQK2oRNm41
R8EecMGkLYjILy488FNOSVDDv4BxBpBOgHe04C6AZNEvvK+6Tza3Yj/HD8gfyShIcQEAPQA2OBEN
sDY2ZjGgMzRk7mLNkClAHpE2zeCuO8bvf8rPy9uzQSOgz2/Qf8v5QIZArsApMDgyLDc0cP3VkznV
Qh9hMIAuoFVBhm/vh3+Igrv5uAJcIEDZzBIAQ0dADnAgPSAm2+Et/j7btBYgln+uwNt1UgPcIIuK
/1tjKJAQUkdFj/AIUFJPj/BOT1JN+EFMKd0IeOHeb99/jEV/jt+P5S8X4mXnr+i/23Np1HplGTAo
Rq9kahDmz3/sz+3fvIDgr+G72kMGkCCAKElTX0VSUupw9XmkKUXwXAAA2czuBkEAwl8EkHIoIlWs
8R5wfz3S2IQiQOowRpbi1TCRXLhcbiLwP+4GCXB0CHDxA6BQVFLxq+HZxk/S37+9+8k//C/9P8xo
KYBhAdCEYzgxoGIwYTNGUP/CUM4fzy//XwBt0j8E3wBe2dVSNCy4QQpAONVBu/muIw9BIlGOy1bx
sFNKMIJOKeB2MC4xIrv5fC8qUkAW4EdgO/CRgUEAU0NJSSBXV1CeTkzWQzIgYBxgKi8K/4EMDE5B
TUVMRQ1A7jMWkAZYDnFOkSeT+hxg3T7RLVtGf2IQ2ysRv49t7yjQkHDdH8RGUz3wU/AwR/8s0Gqh
alIYPxlInyFc4DPg/3WQWxGBg1VownBgAFDAC+LvkN9HT5OPYsJ0xEZRi3lT7RZzaUTgMa8+O2Me
xHSw/46gI1MtQnxRWDRDckhAZkD/giAhWOPAW2H00kmGL6dKKP1cEXBNIJC/Ig8jFWqCc7B/WxFa
ECSHc/NKcYEhbiBkP8DBjSWh4EooNZCboHlwv11ghNONM3WhFLFK0GJ00f8wJMRGMJNz8zwVilg+
2MDw/3VAQ6AHcZQoLevERhX/d+H/RiDCcJ7AYlJJsC2QIIFdIf2YEG9/IGq0o9CBQEsiWaT/Ouk4
dXOjN9HWsEZQgiAWs0dhklwxNPRDUFUmz0H95hBJMyCGUVnDTMFaEBxw/mE9wWqksQi8lQ6RB3BB
Uf8bsGzgYFGWMDrvW5Eb8Vzg33MAXkBYYexgfSBmbiDqwf9+ckmEapXYhysRwZBqIsRG/y3sFrMo
h2vxfnJ4gdawWVT5LihIVyKqTLgwYV4RrIH/9OFbRmuyNzFcgGsh7GAuKD+BYDHqH/gvp0LGxEVR
VLdkoB1xRmYmhJBQwGP5AP99IF0DcxAw0jCESSpxIqZBf0VCMwBeUcRFSKZG4zPQSX+V4QKAwOFK
hC+mKxFboSjjrdCWQCBFeMCEXyNzkP9EsXRArPB0kMRFq3BY8mqV/lDj0V01VxwbGkWDHAaocN/A
8ESxRFR2IHlhZD3BL3H/GANqQGsgPyN31IW4UZsdP/8ZZlNyOAKsEVJhsUFlcBBy1z4A1zDNcD/u
AEnxUDDhn+u3PyAwYWYEKh9vdS1Q/5YBEFOkMWEBKLJSL/bSGzX+KEwBUoXjwm1BYLBTcgGA736w
SlIbsMCRZPThcbOj8PsHcCZWP1cfM/heJE9pHsTnOQE4EESTMjDVoEGwTAHPAoDYIHQEbXF0J1GG
WTj/WgIX1TPSJ+hTc2AUOTImZPvuAFhQZ19AFdBsZsRFF+H9l+Bs+4AexHsiag8ZZk9g34IQFdBO
8XrT7GAlvyAQovvcIHrQOAIQdxxf4ONx6gP9WfJlXiTqkXm2mGCElgGA3+Nx6sCOoUHCxEUiQKDc
gOhmd19f8GLYEHBA1zD+ImXhTfEn4sAgqPAV0ESx+zgQM8JPQkI0oDgQwPCB1v5iM4EfyIL/5kVj
Txs1tOD3rPFjzXccX5Uflgx3HCfT/yaQJbBhMUIBFdDjkEUyFrB/2CEvYSQQU/HXMMBhW2Fh/zxx
EABHkaAQZXNBw5Awo+L/oeBMAOPBJhRMATSwwGA/IDelYDRwqyB3qvH14HVi/0jQ+vBGEKXwMCVh
AH1QTvF/NzHAIMJw1zD1gV2R8VB5/3BAJGBEgVoCS1QVsMyxFdD9SgBjL9Cl8NcwwPChEp+S71oC
ZrLA8CvQcHix+vDqgf8rYHBQiCFMATgCjKOa+aDH+zCToqFlWJE+ImYC44Ir8P9IxDxx9FFMAC1y
AoBP4kIw//sAfVA+Q6JCnUFxIIpQ2MH/PaJh0UoALZB9UCPAYQDAMH+Ys0WBU1DCc6XlmEVCxn0G
fcSQsAAAAAAfAEIAAQAAABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfAGUAAQAAACwAAABx
AHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AZAABAAAACgAAAFMA
TQBUAFAAAAAAAAIBQQABAAAAZAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBpAG4AbgAg
AFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAAJdAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8A5V8BAAAANAAAAHMAaQBwADoAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAfABoMAQAAABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfAB8MAQAA
ACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAA
CgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAZAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBp
AG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAfAAFdAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAB8A+D8BAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AI0ABAAAA
LAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAiQAEAAAAK
AAAAUwBNAFQAUAAAAAAAAgH5PwEAAABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkA
bgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAB8ACV0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgAB
AAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEA
AAAQAAAAzWr+PYTvWUytxa+oHDozDQMAFwABAAAAQAA5AADL0LN8e88BQAAIMIcYOrR8e88BCwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAA
YQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAI
IAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAACMAAAAUgBlADoAIABbAFAAQQBUAEMA
SABdACAAcQBsAGEAMgB4AHgAeAA6ACAAQwBvAG4AdgBlAHIAdAAgAHQAbwAgAHAAZQByAGMAcAB1
AF8AaQBkAGEAIABzAGUAcwBzAGkAbwBuACAAdABhAGcAIABwAHIAZQAtAGEAbABsAG8AYwBhAHQA
aQBvAG4AAAAfAD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhABAAAAcgAAADwAMQA0
ADAAMAA4ADkAOAA4ADAAMgAuADYANAA3ADYALgAyADUALgBjAGEAbQBlAGwAQABoAGEAYQBrAG8A
bgAzAC4AcgBpAHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0APgAAAAAAAgFx
AAEAAAAgAAAAAQHPduyt9VsJtQB3Fk220lO2hsSYM5tPeI8AgAiS/AAfAHAAAQAAAIQAAABbAFAA
QQBUAEMASABdACAAcQBsAGEAMgB4AHgAeAA6ACAAQwBvAG4AdgBlAHIAdAAgAHQAbwAgAHAAZQBy
AGMAcAB1AF8AaQBkAGEAIABzAGUAcwBzAGkAbwBuACAAdABhAGcAIABwAHIAZQAtAGEAbABsAG8A
YwBhAHQAaQBvAG4AAAAfADUQAQAAAHgAAAA8ADUAMAA0AEUAQgA2ADYARABBAEMAOABEADIAMwA0
AEUAQgA4AEUAOAA1ADYAMAA5ADgANQBDADIARAA3AEEARAA0ADYARAAwADkAOQA0AEUAQABhAHYA
bQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAfADkQAQAAANwAAAA8ADEANAAwADAAOAA5
ADIAMgAxADYALQA5ADcAOAA0AC0AMQAtAGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAG4A
YQBiAEAAZABhAHQAZQByAGEAaQBuAGMALgBjAG8AbQA+ACAAPAAxADQAMAAwADgAOQA4ADgAMAAy
AC4ANgA0ADcANgAuADIANQAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4A
ZwB0AGkAZABlAHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+AAAAAwDeP59OAABAAAcwBpMwtHx7zwED
ACYAAAAAAAIBRwABAAAALwAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjItMTQwNTI5MjAyOTM0
Wi0yMjUyODYAAB8AFRABAAAAWAAAAEQAMgA3ADEAMwAwADAAQwAxAEYAMABEAEEAOAA0ADUAQQAx
AEEAMAA2AEMANgAyAEIAQwA1ADMARABBADYAQQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAACARQw
AQAAAAwAAAAlAgAA7XzUKE4AAAAfAPo/AQAAABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAf
AACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEYA
AABNAGkAYwByAG8AcwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBvAGsALwAxADQALgA0AC4AMQAu
ADEANAAwADMAMgA2AAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIA
cwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAARAEAAEkASQA9
ADAAMQAwADEAQwBGADcAQgA3AEMAQgA0ADUAOQBCAEUANQBBADMAOABBAEUAMgBGADQAOAA0ADUA
OAA4ADUARAA5ADUARAA3AEEARABFADgANAAxAEUAMgA7AFMAQgBNAEkARAA9ADEAMgA7AFMAMQA9
ADwAMQA0ADAAMAA4ADkAOAA4ADAAMgAuADYANAA3ADYALgAyADUALgBjAGEAbQBlAGwAQABoAGEA
YQBrAG8AbgAzAC4AcgBpAHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0APgA7
AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMgAgACgAQgB1AGkAbABkACAA
MwA4ADcALgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAA
HwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBp
AHAAAAAAAAEAAAAaAAAAWwAxADAALgAzAC4AMQAwAC4AOAAxAF0AAAAAAIIm

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D0994Eavmb2qlogicorg_--
