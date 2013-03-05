From: Chris Boot <bootc@bootc.net>
Subject: Re: qla2xxx: issues when creating a new target port
Date: Tue, 05 Mar 2013 22:15:01 +0000
Message-ID: <51366E65.9070209@bootc.net>
References: <B1C4F02B-5252-49BC-9FF9-7FB0A74872D8@bootc.net> <1362520375.7905.166.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1362520375.7905.166.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/03/2013 21:52, Nicholas A. Bellinger wrote:
> Hi Chris,
>
> On Sun, 2013-03-03 at 13:49 +0000, Chris Boot wrote:
>> Hi all,
>>
>> When creating a new target port in targetcli (/qla2xxx create
>> 21:0x:...), and I have nothing plugged-in to the port, the creation
>> process takes quite some time. After a few seconds, the kernel prints
>> a message saying "Cable is unplugged...". So far so good.
>>
> AFAIK the delay is expected here when no physical link is detected.

Yes, I expected the delay at this point.

>> It seems that when the target is created, it comes up in the 'enabled'
>> state, regardless of me having set 'auto_enable_tpgt=false'. Running
>> 'disable' from targetcli seems to try to bring the link up again
>> ("Performing ISP error recovery" then "Cable is unplugged...") and the
>> target remains in the enabled state.
>>
> Running 'disable' from targetcli will perform:
>
>   echo 0 > /sys/kernel/config/target/qla2xxx/$FC_WWPN/$TPGT/enable
>
> that will effectively disable target mode on the $FC_WWPN port in
> question, regardless of what else (LUNs, ACLs) are configured.
>
> Target mode is only re-enabled at the HW level for the port with:
>
>   echo 1 > /sys/kernel/config/target/qla2xxx/$FC_WWPN/$TPGT/enable

I can't easily perform this test again now, maybe I can do it later this
weekend. From memory, though, running 'disable' in targetcli _or_
running 'echo 0 >
/sys/kernel/config/target/qla2xxx/$FC_WWPN/$TPGT/enable' both indeed
have the same effect.

>> If I then add LUNs and ACLs to the target, everything appears OK, but
>> plugging the target port into an initiator gives odd behaviour. The
>> initiator spends a very long time scanning the target and eventually
>> times out and finds no LUNs. The only way to get the port working
>> again is to save the configuration and reboot the target server, which
>> is very frustrating.
>>
> Can you double check the value of ../qla2xxx/$FC_WWPN/$TPGT/enable when
> this happens..?  From the description above it sounds like your
> explicitly disabling target mode on the port.

Again, from memory, after doing a 'disable' or 'echo 0 > .../enable'
results in the 'enable' file still returning value 1. I also seem to
remember, when trying to unload the qla2xxx module, getting odd
behaviour and OOPSes - though I would want to double check this. I had
the same behaviour with two qla2xxx HBAs (one 2460 and one 2464).

>> I'm using targetcli as found in Debian wheezy with kernel 3.8.0,
>> though I have had this problem for a little while now...
>>
> For reference, can you provide the HBAs that your reproducing with..?
>
> Also, a target side log with
>
>    modprobe qla2xxx ql2xextended_error_logging=0x7fffffff
>
> would be helpful as well.

I'll see if I can get enough hardware and time together to test this
over the weekend to confirm everything I said above and gather the logs
with the error logging enabled. I'll keep you posted.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
