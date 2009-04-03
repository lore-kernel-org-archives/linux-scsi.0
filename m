From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGTdata)
Date: Fri, 3 Apr 2009 19:52:53 +0200
Message-ID: <e2e108260904031052n49501221y4b0273270e1c58d2@mail.gmail.com>
References: <e2e108260904031008u434e6d06rc7d657a087e64fbc@mail.gmail.com>
	 <C2F174F99918D54CA2A96E57C5079B6F012A9649@sbc-exmsg2.sbcounty.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45293 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZDCRw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 13:52:57 -0400
In-Reply-To: <C2F174F99918D54CA2A96E57C5079B6F012A9649@sbc-exmsg2.sbcounty.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Sufficool, Stanley" <ssufficool@rov.sbcounty.gov>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 3, 2009 at 7:13 PM, Sufficool, Stanley
<ssufficool@rov.sbcounty.gov> wrote:
>> On Thu, Apr 2, 2009 at 7:16 PM, Vladislav Bolkhovitin
>> <vst@vlnb.net> wrote:
>> > Bart Van Assche, on 04/02/2009 12:14 AM wrote:
>> >> I have repeated some of these performance tests for iSCSI
>> >> over IPoIB
>> >> (two DDR PCIe 1.0 ConnectX HCA's connected back to back).
>> >> The results
>> >> for the buffered I/O test with a block size of 512K (initiator)
>> >> against a file of 1GB residing on a tmpfs filesystem on the target
>> >> are as follows:
>> >>
>> >> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
>> >> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
>> >>
>> >> And for a block size of 4 KB:
>> >>
>> >> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
>> >> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.
>> >
>> > Do you have any thoughts why writes are so bad? It shouldn't be so..
>>
>> It's not impossible that with the 4 KB write test I hit the
>> limits of the initiator system (Intel E6750 CPU, 2.66 GHz,
>> two cores). Some statistics I gathered during the 4 KB write test:
>> Target: CPU load 0.5, 16500 mlx4-comp-0 interrupts per
>> second, same number of interrupts processed by each core (8250/s).
>> Initiator: CPU load 1.0, 32850 mlx4-comp-0 interrupts per
>> second, all interrupts occurred on the same core.
>
> Are you using connected mode IPoIB and setting the MTU to 4KB? Would
> fragmentation of IPoIB drive up the interrupt rates?

All tests have been run with default IPoIB settings: an MTU of 2044
bytes and datagram mode. The following data has been obtained from the
target system after several 4 KB write tests:

$ cat /sys/class/net/ib0/mode
datagram
$ /sbin/ifconfig ib0
ib0       Link encap:UNSPEC  HWaddr
80-00-00-48-FE-80-00-00-00-00-00-00-00-00-00-00
          inet addr:192.168.2.1  Bcast:192.168.2.255  Mask:255.255.255.0
          inet6 addr: fe80::202:c903:2:d217/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:2044  Metric:1
          RX packets:88482013 errors:0 dropped:0 overruns:0 frame:0
          TX packets:38444824 errors:0 dropped:11 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:135770573672 (129480.9 Mb)  TX bytes:5647702210 (5386.0 Mb)

Bart.
