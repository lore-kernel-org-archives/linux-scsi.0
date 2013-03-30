From: Chris Boot <bootc@bootc.net>
Subject: Re: qla2xxx: issues when creating a new target port
Date: Sat, 30 Mar 2013 21:42:03 +0000
Message-ID: <51575C2B.3070607@bootc.net>
References: <B1C4F02B-5252-49BC-9FF9-7FB0A74872D8@bootc.net> <1362520375.7905.166.camel@haakon2.linux-iscsi.org> <51366E65.9070209@bootc.net> <513A575D.3000208@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <513A575D.3000208@bootc.net>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/03/2013 21:25, Chris Boot wrote:
> On 05/03/13 22:15, Chris Boot wrote:
>> I'll see if I can get enough hardware and time together to test this
>> over the weekend to confirm everything I said above and gather the logs
>> with the error logging enabled. I'll keep you posted.
>
> I have run some tests against 3.8.2, and attached the logs.
>
> I can only replicate the problems I ran into with the following 
> sequence of events:
>
> 1. Link on the qla246x target must be down to start with (tested with 
> QLA2460 and QLA2464).
> 2. /qla2xxx create 21:00:00:1b:32:11:a8:24
> 3. disable
> 4. luns/ create /backstores/iblock/test
> 5. acls/ create 10:00:00:06:2b:11:3f:a1
> 6. enable
> 7. Plug in the link to an initiator.
>
> Even with 'set global auto_enable_tpgt=false', at step 3 the port 
> comes up enabled. It seems I remembered wrongly that disabling the 
> target port does not successfully disable it:
>
> jones-hdd bootc # cat 
> /sys/kernel/config/target/qla2xxx/21\:00\:00\:1b\:32\:11\:a8\:24/tpgt_1/enable 
>
> 1
> jones-hdd bootc # echo 0 > 
> /sys/kernel/config/target/qla2xxx/21\:00\:00\:1b\:32\:11\:a8\:24/tpgt_1/enable
> jones-hdd bootc # cat 
> /sys/kernel/config/target/qla2xxx/21\:00\:00\:1b\:32\:11\:a8\:24/tpgt_1/enable 
>
> 0
>
> Once the target is configured with a LUN and ACL, enabled, and the 
> link brought up by an initiator, the initiator fails to see any LUNs 
> and eventually times out. The debug logging shows interesting lines 
> such as:
>
> Mar  8 21:06:59 jones-hdd kernel: [  183.441093] qla2xxx 
> [0000:01:00.0]-f821:4: New command while device ffff8801a1b51400 is 
> shutting down
> Mar  8 21:06:59 jones-hdd kernel: [  183.441096] qla2xxx 
> [0000:01:00.0]-e859:4: qla_target: Unable to send command to target 
> for req, ignoring.
>
> I definitely think there is a bug in there, and it feels like it's 
> triggered by disabling the target port with the link down - but I'm 
> only guessing at this point.

Hi folks,

Has anyone had a chance to look at the above?

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
