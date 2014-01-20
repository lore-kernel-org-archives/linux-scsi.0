From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
Date: Mon, 20 Jan 2014 11:43:46 -0800
Message-ID: <CAADnVQKcvGz4KLb--PyXPVeNohRsumFVr=tK8or1TFhQL3qqyA@mail.gmail.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
	<CAADnVQLUP=7oxciVw97d76xtqs6_YjC6E2boPRO9y4m_sqjRCA@mail.gmail.com>
	<CAADnVQL=s8zc_ACSuPs8P3y-RB9Td8OZysM=0fj4sjzUPRzfGw@mail.gmail.com>
	<20140117210201.GA390@x4>
	<CAADnVQL7zB2y0w4F-hYZ=RBe1bQg3X5pp-h=74HYZ1OSJ1K0xw@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1A6A38A3@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A6A38A3@IRSMSX105.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sebastian.riemer@profitbricks.com" <sebastian.riemer@profitbricks.com>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 18, 2014 at 3:31 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> On Friday, January 17, 2014 10:44 PM Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>> On Fri, Jan 17, 2014 at 1:02 PM, Markus Trippelsdorf
>> <markus@trippelsdorf.de> wrote:
>> > On 2014.01.17 at 11:58 -0800, Alexei Starovoitov wrote:
>> >> On Fri, Jan 17, 2014 at 9:58 AM, Alexei Starovoitov
>> >> <alexei.starovoitov@gmail.com> wrote:
>> >> > On Fri, Jan 17, 2014 at 5:37 AM, Dorau, Lukasz <lukasz.dorau@intel.com>
>> wrote:
>> >> >> Hi
>> >> >>
>> >> >> My story is very simply...
>> >> >> I applied the following patch:
>> >> >>
>> >> >> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
>> >> >> --- a/drivers/scsi/isci/init.c
>> >> >> +++ b/drivers/scsi/isci/init.c
>> >> >> @@ -698,8 +698,11 @@ static int isci_pci_probe(struct pci_dev *pdev, const
>> struct pci_device_id *id)
>> >> >>         if (err)
>> >> >>                 goto err_host_alloc;
>> >> >>
>> >> >> -       for_each_isci_host(i, isci_host, pdev)
>> >> >> +       for_each_isci_host(i, isci_host, pdev) {
>> >> >> +               pr_err("(%d < %d) == %d\n",\
>> >> >> +                      i, SCI_MAX_CONTROLLERS, (i < SCI_MAX_CONTROLLERS));
>> >> >>                 scsi_scan_host(to_shost(isci_host));
>> >> >> +       }
>> >> >>
>> >> >>         return 0;
>> >> >>
>> >> >> --
>> >> >> 1.8.3.1
>> >> >>
>> >> >> Then I issued the command 'modprobe isci' on platform with two SCU
>> controllers (Patsburg D or T chipset)
>> >> >> and received the following, very strange, output:
>> >> >>
>> >> >> (0 < 2) == 1
>> >> >> (1 < 2) == 1
>> >> >> (2 < 2) == 1
>> >> >>
>> >> >> Can anyone explain why (2 < 2) is true? Is it a gcc bug?
>> >> >
>> >> > gcc sees that i < array_size is the same as i < 2 as part of loop condition, so
>> >> > it optimizes (i < sci_max_controllers) into constant 1.
>> >> > and emits printk like:
>> >> >   printk ("\13(%d < %d) == %d\n", i_382, 2, 1);
>> >> >
>> >> >> (The kernel was compiled using gcc version 4.8.2.)
>> >> >
>> >> > it actually looks to be gcc 4.8 bug.
>> >> > Can you try gcc 4.7 ?
>> >> >
>> >>
>> >> It is interesting GCC 4.8 bug,
>> >> since it seems to expose issues in two compiler passes.
>> >>
>> >> here is test case:
>> >>
>> >> struct isci_host;
>> >> struct isci_orom;
>> >>
>> >> struct isci_pci_info {
>> >>   struct isci_host *hosts[2];
>> >>   struct isci_orom *orom;
>> >> } v = {{(struct isci_host *)1,(struct isci_host *)1}, 0};
>> >>
>> >> int printf(const char *fmt, ...);
>> >>
>> >> int isci_pci_probe()
>> >> {
>> >>   int i;
>> >>   struct isci_host *isci_host;
>> >>
>> >>   for (i = 0, isci_host = v.hosts[i];
>> >>        i < 2 && isci_host;
>> >>        isci_host = v.hosts[++i]) {
>> >>     printf("(%d < %d) == %d\n", i, 2, (i < 2));
>> >>   }
>> >>
>> >>   return 0;
>> >> }
>> >>
>> >> int main()
>> >> {
>> >>   isci_pci_probe();
>> >> }
>> >>
>> >> $ gcc bug.c
>> >> $./a.out
>> >> 0 < 2) == 1
>> >> (1 < 2) == 1
>> >> $ gcc bug.c -O2
>> >> $ ./a.out
>> >> (0 < 2) == 1
>> >> (1 < 2) == 1
>> >> Segmentation fault (core dumped)
>> >
>> > Your testcase is invalid:
>> >
>> > markus@x4 tmp % clang -fsanitize=undefined -Wall -Wextra -O2 bug.c
>> > markus@x4 tmp % ./a.out
>> > (0 < 2) == 1
>> > (1 < 2) == 1
>> > bug.c:16:20: runtime error: index 2 out of bounds for type 'struct isci_host *[2]'
>> >
>> > As Jakub Jelinek said on IRC, changing the loop to e.g.:
>> >
>> >   for (i = 0;
>> >        i < 2 && (isci_host = v.hosts[i]);
>> >        i++) {
>> >
>> > fixes the issue.
>>
>> testcase was reduced from drivers/scsi/isci/host.h written back in
>> 2011 (commit b329aff107)
>> #define for_each_isci_host(id, ihost, pdev) \
>>         for (id = 0, ihost = to_pci_info(pdev)->hosts[id]; \
>>              id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
>>              ihost = to_pci_info(pdev)->hosts[++id])
>>
>> yes, it does access 3rd element of 2 element array and will read junk.
>>
>> C standard says the behavior is undefined and comes handy in compiler defense,
>> but in this case compiler has obviously all the information to make
>> right decision
>> instead of misoptimizing the code.
>> So yes, the loop is erroneous, non-portable, etc, but gcc can be smarter.
>> --
>
> Thank you for explanation!
>
> Alexei,
>
> Will you file a gcc bug for this case?

sure. filed for the record:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59892
Closed as invalid by Markus already.
