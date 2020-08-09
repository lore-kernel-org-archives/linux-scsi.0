Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8E4C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 09:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75DAE20729
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 09:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHIJU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 05:20:59 -0400
Received: from comms.puri.sm ([159.203.221.185]:42294 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgHIJU7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 9 Aug 2020 05:20:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 3FCFFE039C;
        Sun,  9 Aug 2020 02:20:28 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 50z1enKKyXPh; Sun,  9 Aug 2020 02:20:27 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <1596037482.4356.37.camel@HansenPartnership.com>
 <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
 <20200729182515.GB1580638@rowland.harvard.edu>
 <1596047349.4356.84.camel@HansenPartnership.com>
 <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
 <20200730151030.GB6332@rowland.harvard.edu>
 <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Autocrypt: addr=martin.kepplinger@puri.sm; keydata=
 mQINBFULfZABEADRxJqDOYAHfrp1w8Egcv88qoru37k1x0Ugy8S6qYtKLAAt7boZW+q5gPv3
 Sj2KjfkWA7gotXpASN21OIfE/puKGwhDLAySY1DGNMQ0gIVakUO0ji5GJPjeB9JlmN5hbA87
 Si9k3yKQQfv7Cf9Lr1iZaV4A4yjLP/JQMImaCVdC5KyqJ98Luwci1GbsLIGX3EEjfg1+MceO
 dnJTKZpBAKd1J7S2Ib3dRwvALdiD7zqMGqkw5xrtwasatS7pc6o/BFgA9GxbeIzKmvW/hc3Q
 amS/sB12BojyzdUJ3TnIoAqvwKTGcv5VYo2Z+3FV+/MJVXPo8cj2vmfxQx1WG4n6X0pK4X8A
 BkCKw2N/evMZblNqAzzGVtoJvqQYkzQ20Fm+d3wFl6lS1db4MB+kU13G8kEIE22Q3i6kx4NA
 N49FLlPeDabGfJUyDaZp5pmKdcd7/FIGH/HjShjx7g+LKSwWNMkDygr4WARAP4h8zYDZuNqe
 ofPvMLqJxHeexBPIGF/+OwMyTvM7otP5ODuFmq6OqjNPf1irJmkiFv3yEa+Ip0vZzwl4XvrZ
 U0IKjSy2rbRLg22NsJT0XVZJbutIXYSvIHGqSxzzfiOOLnRjR++fbeEoVlRJ4NZHDKCh3pJv
 LNd+j03jXr4Rm058YLgO7164yr7FhMZniBJw6z648rk8/8gGPQARAQABtC1NYXJ0aW4gS2Vw
 cGxpbmdlciA8bWFydGluLmtlcHBsaW5nZXJAcHVyaS5zbT6JAk4EEwEIADgWIQTyCCuID55C
 OTRobj9QA5jfWrOH0wUCXPSlkwIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRBQA5jf
 WrOH06/FEACC/GTz88DOdWR5JgghjtOhaW+EfpFMquJaZwhsaVips7ttkTKbf95rzunhkf2e
 8YSalWfmyDzZlf/LKUTcmJZHeU7GAj/hBmxeKxo8yPWIQRQE74OEx5MrwPzL6X7LKzWYt4PT
 66bCD7896lhmsMP/Fih2SLKUtL0q41J2Ju/gFwQ6s7klxqZkgTJChKp4GfQrBSChVyYxSyYG
 UtjS4fTFQYfDKTqwXIZQgIt9tHz4gthJk4a6ZX/b68mRd11GAmFln8yA1WLYCQCYw+wsvCZ0
 Ua7gr6YANkMY91JChnezfHW/u/xZ1cCjNP2wpTf4eTMsV1kxW6lkoJRQv643PqzRR2rJPEaS
 biyg7AFZWza/z7rMB5m7r3wN7BKKAj7Lvt+xoLcncx4jLjgSlROtyRTrctBFXT7cIhcGWHw+
 Ib42JF0u96OlPYhRsaIVS3KaD40jMrXf6IEsQw3g6DnuRb2t5p61OX/d9AIcExyYwbdStENN
 gW9RurhmvW3z9gxvFEByjRE+uVoVuVPsZXwAZqFMi/iK4zRfnjdINYMcxKpjhj8vUdBDtZH3
 IpgcI8NemE3B3w/7d3aPjIBz3Igo5SJ3x9XX4hfiWXMU3cT7b5kPcqEN0uAW5RmTA/REC956
 rzZYU7WnSgkM8E8xetz5YuqpNeAmi4aeTPiKDo6By8vfJbkCDQRVC32QARAAxTazPZ9jfp6u
 C+BSiItjwkrFllNEVKptum98JJovWp1kibM+phl6iVo+wKFesNsm568viM2CAzezVlMr7F0u
 6NQNK6pu084W9yHSUKROFFr83Uin6t04U88tcCiBYLQ5G+TrVuGX/5qY1erVWI4ycdkqQzb8
 APbMFrW/sRb781f8wGXWhDs6Bd4PNYKHv7C0r8XYo77PeSqGSV/55lpSsmoE2+zR3MW5TVoa
 E83ZxhfqgtTIWMf88mg/20EIhYCRG0iOmjXytWf++xLm9xpMeKnKfWXQxRbfvKg3+KzF30A0
 hO3YByKENYnwtSBz8od32N7onG5++azxfuhYZG5MkaNeJPLKPQpyGMc2Ponp0BhCZTvxIbI8
 1ZeX6TC+OZbeW+03iGnC7Eo4yJ93QUkzWFOhGGEx0FHj+qBkDQLsREEYwsdxqqr9k1KUD1GF
 VDl0gzuKqiV4YjlJiFfHh9fbTDztr3Nl/raWNNxA3MtX9nstOr7b+PoA4gH1GXL9YSlXdfBP
 VnrhgpuuJYcqLy02i3/90Ukii990nmi5CzzhBVFwNjsZTXw7NRStIrPtKCa+eWRCOzfaOqBU
 KfmzXEHgMl4esqkyFu2MSvbR6clIVajkBmc4+dEgv13RJ9VWW6qNdQw7qTbDJafgQUbmOUMI
 ygDRjCAL2st/LiAi2MWgl80AEQEAAYkCHwQYAQIACQUCVQt9kAIbDAAKCRBQA5jfWrOH0wSZ
 EACpfQPYFL4Ii4IpSujqEfb1/nL+Mi+3NLrm8Hp3i/mVgMrUwBd4x0+nDxc7+Kw/IiXNcoQB
 Q3NC1vsssJ6D+06JOnGJWB9QwoyELGdQ7tSWna405rwDxcsynNnXDT0d39QwFN2nXCyys+7+
 Pri5gTyOByJ+E52F27bX29L05iVSRREVe1zLLjYkFQ4LDNStUp/camD6FOfb+9uVczsMoTZ1
 do2QtjJMlRlhShGz3GYUw52haWKfN3tsvrIHjZf2F5AYy5zOEgrf8O3jm2LDNidin830+UHb
 aoJVibCTJvdbVqp/BlA1IKp1s/Y88ylSgxDFwFuXUElJA9GlmNHAzZBarPEJVkYBTHpRtIKp
 wqmUTH/yH0pzdt8hitI+RBDYynYn0nUxiLZUPAeM5wRLt1XaQ2QDc0QJR8VwBCVSe8+35gEP
 dO/QmrleN5iA3qOHMW8XwXJokd7MaS6FJKGdFjjZPDMR4Qi8PTn2Lm1NkDHpEtaEjjKmdrt/
 4OpE6fV4iKtC1kcvOtvqxNXzmFn9yabHVlbMwTY2TxF8ImfZvr/1Sdzbs6yziasNRfxTGmmY
 G2rmB/XO6AMdal5ewWDFfVmIiRoiVdMSuVM6QxrDnyCfP7W8D0rOqTWQwCWrWv///vz8vfTb
 WlN21GIcpbgBmf9lB8oBpLsmZyXNplhQVmFlorkCDQRc9Ka1ARAA1/asLtvTrK+nr7e93ZVN
 xLIfNO4L70TlBQEjUdnaOetBWQoZNH1/vaq84It4ZNGnd0PQ4zCkW+Z90tMftZIlbL2NAuT1
 iQ6INnmgnOpfNgEag2/Mb41a57hfP9TupWL5d2zOtCdfTLTEVwnkvDEx5TVhujxbdrEWLWfx
 0DmrI+jLbdtCene7kDV+6IYKDMdXKVyTzHGmtpn5jZnXqWN4FOEdjQ0IPHOlc1BT0lpMgmT6
 cSMms5pH3ZYf9tHG94XxKSpRpeemTTNfMUkFItU6+gbw9GIox6Vqbv6ZEv0PAhbKPoEjrbrp
 FZw9k0yUepX0e8nr0eD4keQyC6WDWWdDKVyFFohlcBiFRb6BchJKm/+3EKZu4+L1IEtUMEtJ
 Agn1eiA42BODp2OG4FBT/wtHE7CYhHxzyKk/lxxXy2QWGXtCBIK3LPPclMDgYh0x0bosY7bu
 3tX4jiSs0T95IL3Yl4weMClAxQRQYt45EiESWeOBnl8AHV8YDwy+O7uIT2OHpxvdY7YK1gHN
 i5E3yaI0XCXXtyw82LIAOxcCUuMkuNMsBOtBM3gHDourxrNnYxZEDP6UcoJn3fTyevRBqMRa
 QwUSHuo0x6yvjzY2HhOHzrg3Qh7XLn8mxIr/z82kn++cD/q3ewEe6uAXkt7I12MR0jbihGwb
 8KZWlwK9rYAtfCMAEQEAAYkEcgQYAQgAJhYhBPIIK4gPnkI5NGhuP1ADmN9as4fTBQJc9Ka1
 AhsCBQkDwmcAAkAJEFADmN9as4fTwXQgBBkBCAAdFiEER3IIz/s0aDIAhj4GfiztzT9UrIUF
 Alz0prUACgkQfiztzT9UrIUfiBAAt3N8bUUH2ZQahtVO2CuEiHyc3H0f8BmEVGzvnDcmoJEf
 H6uS/0kF0Y05aX+U6oYg/E9VWztA6E6guC7Bz9zr6fYZaLnDefzkuDRQAzZzBNpxcUrJheOk
 YDAa/8fORIQXJO12DSOq4g9X2RSqIcmQgx2/KoW4UG3e4OArqgMS7ESDT6uT1WFcscfqjPJX
 jXKIH3tg/aJ7ZDkGMFanYsDaiII1ZKpor9WZAsfImPi0n2UZSNEZZtXoR6rtp4UT+O3QrMrn
 MZQlOBkv2HDq1Fe1PXMiFst5kAUcghIebyHdRhQABI7rLFeUqHoEVGuAyuayTsVNecMse7pF
 O44otpwFZe+5eDTsEihY1LeWuXIkjBgo0kmNTZOTwjNeL2aDdpZzN70H4Ctv6+r24248RFMi
 y1YUosIG/Un6OKY4hVShLuXOqsUL41j4UJKRClHEWEIFFUhUgej3Ps1pUxLVOI+ukhAUJwWw
 BagsKq/Gb8T/AhH3noosCHBXeP5ZyT5vMmHk2ZvwwWQnUJVHBAv2e9pXoOWMepyaTs/N9u4u
 3HG3/rYSnYFjgl4wzPZ73QUvCxEYfJi9V4Yzln+F9hK6hKj3bKHAQivx+E3NvFuIIM1adiRh
 hQClh2MaZVy94xU6Sftl9co3BsilV3H7wrWd5/vufZlZDtHmPodae7v5AFmavrIXFxAAsm4Z
 OwwzhG6iz+9mGakJBWjXEKxnAotuI2FCLWZV/Zs8tfhkbeqYFO8Vlz3o0sj+r63sWFkVTXOb
 X7jCQUwW7HXEdMaCaDfC6NUkkKT1PJIBC+kpcVPSq4v/Nsn+yg+K+OGUbHjemhjvS77ByZrN
 /IBZOm94DSYgZQJRTmTVYd96G++2dMPOaUtWjqmCzu3xOfpluL1dR19qCZjD1+mAx5elqLi7
 BrZgJOUjmUb/XI/rDLBpoFQ/6xNJuDA4UTi1d+eEZecOEu7mY1xBQkvKNXL6esqx7ldieaLN
 Af4wUksA+TEUl2XPu84pjLMUbm0FA+sUnGvMkhCn8YdQtEbcgNYq4eIlOjHW+h7zU2G5/pm+
 FmxNAJx7iiXaUY9KQ3snoEz3r37RxEDcvTY9KKahwxEzk2Mf58OPVaV4PEsRianrmErSUfmp
 l93agbtZK1r5LaxeItFOj+O2hWFLNDenJRlBYwXwlJCiHxM/O273hZZPoP8L5p54uXhaS5EJ
 uV2Xzgbi3VEbw3GZr+EnDC7XNE2wUrnlD/w2W6RzVYjVT6IX4SamNlV+MWX0/1fYCutfqZl8
 6BSKmJjlWpfkPKzyzjhGQVZrTZYnKAu471hRv8/6Dx5JuZJgDCnYanNx3DDreRMu/nq6TfaO
 ekMtxgNYb/8oDry09UFHbGHLsWn6oBo=
Message-ID: <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
Date:   Sun, 9 Aug 2020 11:20:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200808150542.GB256751@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08.08.20 17:05, Alan Stern wrote:
> On Sat, Aug 08, 2020 at 08:59:09AM +0200, Martin Kepplinger wrote:
>> On 07.08.20 16:30, Alan Stern wrote:
>>> On Fri, Aug 07, 2020 at 11:51:21AM +0200, Martin Kepplinger wrote:
>>>> it's really strange: below is the change I'm trying. Of course that's
>>>> only for testing the functionality, nothing how a patch could look like.
>>>>
>>>> While I remember it had worked, now (weirdly since I tried that mounting
>>>> via fstab) it doesn't anymore!
>>>>
>>>> What I understand (not much): I handle the error with "retry" via the
>>>> new flag, but scsi_decide_disposition() returns SUCCESS because of "no
>>>> more retries"; but it's the first and only time it's called.
>>>
>>> Are you saying that scmd->allowed is set to 0?  Or is scsi_notry_cmd() 
>>> returning a nonzero value?  Whichever is true, why does it happen that 
>>> way?
>>
>> scsi_notry_cmd() is returning 1. (it's retry 1 of 5 allowed).
>>
>> why is it returning 1? REQ_FAILFAST_DEV is set. It's DID_OK, then "if
>> (status_byte(scmd->result) != CHECK_CONDITION)" appearently is not true,
>> then at the end it returns 1 because of REQ_FAILFAST_DEV.
>>
>> that seems to come from the block layer. why and when? could I change
>> that so that the scsi error handling stays in control?
> 
> The only place I see where that flag might get set is in 
> blk_mq_bio_to_request() in block/blk-mq.c, which does:
> 
> 	if (bio->bi_opf & REQ_RAHEAD)
> 		rq->cmd_flags |= REQ_FAILFAST_MASK;
> 
> So apparently read-ahead reads are supposed to fail fast (i.e., without 
> retries), presumably because they are optional after all.
> 
>>> What is the failing command?  Is it a READ(10)?
>>
>> Not sure how I'd answer that, but here's the test to trigger the error:
>>
>> mount /dev/sda1 /mnt
>> cd /mnt
>> ls
>> cp file ~/ (if ls "works" and doesn't yet trigger the error)
>>
>> and that's the (familiar looking) logs when doing so. again: despite the
>> mentioned workaround in scsi_error and the new expected_media_change
>> flag *is* set and gets cleared, as it should be. REQ_FAILFAST_DEV seems
>> to override what I want to do is scsi_error:
>>
>> [   55.557629] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
>> hostbyte=0x00 driverbyte=0x08 cmd_age=0s
>> [   55.557639] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
>> [   55.557646] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
>> [   55.557657] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 08 fc
>> e0 00 00 01 00
> 
> Yes, 0x28 is READ(10).  Likely this is a read-ahead request, although I 
> don't know how we can tell for sure.
> 
>> [   55.557666] blk_update_request: I/O error, dev sda, sector 589024 op
>> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
>> [   55.568899] sd 0:0:0:0: [sda] tag#0 device offline or changed
>> [   55.574691] blk_update_request: I/O error, dev sda, sector 589025 op
>> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
>> [   55.585756] sd 0:0:0:0: [sda] tag#0 device offline or changed
>> [   55.591562] blk_update_request: I/O error, dev sda, sector 589026 op
>> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
>> [   55.602274] sd 0:0:0:0: [sda] tag#0 device offline or changed
>> (... goes on with the same)
> 
> Is such a drastic response really appropriate for the failure of a 
> read-ahead request?  It seems like a more logical response would be to 
> let the request fail but keep the device online.
> 
> Of course, that would only solve part of your problem -- your log would 
> still get filled with those "I/O error" messages even though they 
> wouldn't be fatal.  Probably a better approach would be to make the new 
> expecting_media_change flag override scsi_no_retry_cmd().
> 
> But this is not my area of expertise.  Maybe someone else will have more 
> to say.
> 
> Alan Stern
> 

Hey Alan, I'm really glad for that, I suspected some of this but I have
little experience in scsi/block layers, so that is super helpful.

I'd appreciate an opinion on the below workaround that *seems* to work
now (let's see, I had thought so before :)

Whether or not this helps to find a real solution, let's see. But
integration of such a flag in the error handling paths is what's
interesting for now:


--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -565,6 +565,17 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 				return NEEDS_RETRY;
 			}
 		}
+		if (scmd->device->expecting_media_change) {
+			if (sshdr.asc == 0x28 && sshdr.ascq == 0x00) {
+				/* clear expecting_media_change in
+				 * scsi_noretry_cmd() because we need
+				 * to override possible "failfast" overrides
+				 * that block readahead can cause.
+				 */
+				return NEEDS_RETRY;
+			}
+		}
+
 		/*
 		 * we might also expect a cc/ua if another LUN on the target
 		 * reported a UA with an ASC/ASCQ of 3F 0E -
@@ -1744,6 +1755,15 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
 	}

+	/*
+	 * We need to have retries when expecting_media_change is set.
+	 * So we need to return success and clear the flag here.
+	 */
+	if (scmd->device->expecting_media_change) {
+		scmd->device->expecting_media_change = 0;
+		return 0;
+	}
+
 	if (status_byte(scmd->result) != CHECK_CONDITION)
 		return 0;

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..bb583e403b81 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3642,6 +3642,8 @@ static int sd_resume(struct device *dev)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;

+	sdkp->device->expecting_media_change = 1;
+
 	if (!sdkp->device->manage_start_stop)
 		return 0;

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..f5fc1af68e00 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -169,6 +169,7 @@ struct scsi_device {
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
 				     * because we did a bus reset. */
+	unsigned expecting_media_change:1;
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
--
