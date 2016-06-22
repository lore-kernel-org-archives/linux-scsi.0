From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Wed, 22 Jun 2016 09:45:06 -0600
Message-ID: <CAANLjFq7b27WQM4H9Oujongyxp=gmJO5nG0RrzgYMzm-b81jYQ@mail.gmail.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com> <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
 <57582336.10407@mellanox.com> <CAANLjFrLK-ZVP5XX3TnkAMz+7_pd6qc+c88mbF4vF9DQ+F5U=A@mail.gmail.com>
 <CAANLjFrv-0VArTEkgqbrhzFjn1fg_egpCJuQZnAurVrHjbL_qA@mail.gmail.com>
 <CAANLjFqoV-5HK0c+LdEbuxd81Vm=g=WE3cQgp47dH-yfYjZjGw@mail.gmail.com>
 <57693C6A.3020805@gmail.com> <CAANLjFpUyAYB+ZzMwFKBpa4yLmALPzcRGJX1kExVrLARZmZRkA@mail.gmail.com>
 <CAANLjFpeL0AkuGW-q5Bmm-dff0UqFOM_sAOaG7=vyqmwnOoTcQ@mail.gmail.com> <86d4404a-fa6a-72de-8e83-827072c308b5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86d4404a-fa6a-72de-8e83-827072c308b5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

There is no need to be concerned about srpt crashing in the latest
kernel. Srpt only crashed when I was testing kernels in that change
set (7861728..5e47f19) that I identified the 10-15% performance drop
in iSER between the 4.5 and 4.6 kernel. My tests from the 4.6 to
4.7rc3 didn't have a problem with srpt crashing.

The format of the output is as follows:

Kernel_tag_commit
iSER tests with results in this format
<dev>;<target IP>;<bandwidth KB/s>;<IOPs>;<execution time ms> (last
three fields are fields 7,8,9 from fio)
i.e. sdc;10.218.128.17;3260244;815061;25730
SRP LIO tests
<IB driver>;<dev>;<bandwidth KB/s>;<IOPs>;<execution time ms>
i.e. mlx5_0;sdd;2986864;746716;28085

This is repeated for each kernel tested. On some tests I also
documented the observed CPU utilization of some of the target
processes. In some cases I was lazy and if the information was the
same for both mlx5 targets, I didn't duplicate it. For iSER, there are
four aliases on each adapter to provide four paths for each IB port
(this is a remnant of some previous multipathing tests, and now only
serves as providing additional data points to know how repeatable the
tests are). 10.218.*.17 and 10.219.*.17 are generally on the mlx5
ports while 19.220.*.17 are on the mlx4 port (some tests had the
adapters swapped, but none of these did and it is easy to identify
them by the grouping).

This test was performed against each path individually. I created an
ext4 filesystem on the device (no partitions), then would mount the
file system on one path, run the test, umount the path, mount the next
path, run the test, etc so that there is no multipathing confusing the
tests. I also am _NOT_ running the tests on all paths at the same time
using fio.

The fio command I'm using is: fio --rw=read --bs=4K --size=2G
--numjobs=40 --name=worker.matt --group_reporting --minimal |  cut
-d';' -f7,8,9

I hope that clears up the confusion, if not, please ask for more clarification.

On Jun 22, 2016 2:18 AM, "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>
> On 06/21/2016 10:26 PM, Robert LeBlanc wrote:
>>
>> Srpt keeps crashing couldn't test
>
>
> If this is reproducible with the latest rc kernel or with any of the stable kernels please report this in a separate e-mail, together with the crash call stack and information about how to reproduce this.
>
> Thanks,
>
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
