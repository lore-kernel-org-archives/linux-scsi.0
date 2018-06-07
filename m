From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Fwd: [powerpc/Baremetal]Kernel OOPS while executing memory
 hotplug on Power8 baremetal
Date: Thu, 07 Jun 2018 22:51:44 +1000
Message-ID: <87wovaahen.fsf@concordia.ellerman.id.au>
References: <ee45ead1d96ad05f77aec1d8d3e39c85@linux.vnet.ibm.com>
 <d5b62afc48ece5aca8d08a80871c8613dd555d17.camel@wdc.com>
 <d011631b-c667-2628-dda8-2c87961329f0@linux.vnet.ibm.com>
 <042fc8ee69b74c57815c0edfdbb253495e9d7718.camel@wdc.com>
 <e01428cf15ab45bd42a45a14424e5384@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <e01428cf15ab45bd42a45a14424e5384@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: vrbagal1 <vrbagal1@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, axboe@kernel.dk, kent.overstreet@gmail.com, snitzer@redhat.com, linux-block@vger.kernel.org
Cc: sachinp@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, Linuxppc-dev <linuxppc-dev-bounces+vrbagal1=linux.vnet.ibm.com@lists.ozlabs.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

vrbagal1 <vrbagal1@linux.vnet.ibm.com> writes:
> On 2018-06-07 13:12, Bart Van Assche wrote:
>> On Thu, 2018-06-07 at 12:56 +0530, Venkat Rao B wrote:
>>> On Thursday 07 June 2018 12:46 PM, Bart Van Assche wrote:
>>> > On Thu, 2018-06-07 at 12:38 +0530, vrbagal1 wrote:
>>> > > Observing Kernel oops and machine reboots while executing memory hotplug
>>> > > test case, on Power8 Baremetal machine.
>>> > >
>>> > > I see this is introduced some where between rc6 and 4.17.
>>> >
>>> > Please provide the exact versions (git commit IDs) of the kernel versions
>>> > you have tested.
>>> 
>>> Commit Id ---> 5037be168f
>> 
>> The reason I was asking for the commit ID is because I saw that 
>> clone_endio()
>> occurs in the oops which means that the dm driver is involved. An 
>> important fix
>> for the dm driver went upstream recently, namely d37753540568 ("dm: Use 
>> kzalloc
>> for all structs with embedded biosets/mempools"). Can you double check 
>> whether
>> that commit it present in your tree? If it is not present, please 
>> update to the
>> latest master and retest. If it is present, please report how to 
>> reproduce
>> this oops to Kent Overstreet, Jens Axboe, linux-block and Mike Snitzer.
>> 
>> Thanks,
>> 
>> Bart.
>
>
> Yes, the fix is present in the tree, which I have tested.
>
> Steps to reproduce:
>
> Step1: Clone and Install avocado git clone 
> https://github.com/avocado-framework/avocado.git
> Step2: Clone 
> https://github.com/avocado-framework-tests/avocado-misc-tests.git
>         Test case is 
> https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/memhotplug.py
> Step3: Command to run the test is avocado run 
> avocado-misc-tests/memory/memhotplug.py

That gave me:

  $ avocado run avocado-misc-tests/memory/memhotplug.py
  avocado: command not found

Was I meant to install it?

I tried this which worked (I think):

  $ ./scripts/avocado run avocado-misc-tests/memory/memhotplug.py
  Failed to load plugin from module "avocado_runner_vm": ImportError('No module named libvirt',)
  JOB ID     : 28deb5a455fb876a7e177deb2b46eab640f313c8
  JOB LOG    : /home/michael/avocado/job-results/job-2018-06-07T22.27-28deb5a/job.log
   (1/4) avocado-misc-tests/memory/memhotplug.py:memstress.test_hotplug_loop: PASS (10.62 s)
   (2/4) avocado-misc-tests/memory/memhotplug.py:memstress.test_hotplug_toggle: PASS (245.15 s)
   (3/4) avocado-misc-tests/memory/memhotplug.py:memstress.test_dlpar_mem_hotplug: PASS (0.37 s)
   (4/4) avocado-misc-tests/memory/memhotplug.py:memstress.test_hotplug_per_numa_node: PASS (41.09 s)
  RESULTS    : PASS 4 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0 | CANCEL 0
  JOB TIME   : 323.45 s
  JOB HTML   : /home/michael/avocado/job-results/job-2018-06-07T22.27-28deb5a/results.html


So what's different about your system?

What does 'lsblk -O' say on your system?

cheers
