From: Shuah Khan <shuahkhan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Thu, 10 Apr 2014 17:17:44 -0600
Message-ID: <CAKocOONaqGAaiesf_MUFXEOMDtX8R8kYuPQYAxLBfth7nAx3Jg@mail.gmail.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	<1397084904.9519.62.camel@dabdike>
	<1397085044.9519.63.camel@dabdike>
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	<1397087425.9519.67.camel@dabdike>
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	<20140410204525.GC21815@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20140410204525.GC21815-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "open list:INTEL IOMMU (VT-d)" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 10, 2014 at 2:45 PM,  <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org> wrote:
>> > 3f583bc21977 BAD ("Merge tag 'iommu-updates-v3.15'")
>>
>> Yes, specifically (finally done bisecting):
>>
>> commit 2e45528930388658603ea24d49cf52867b928d3e
>> Author: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Date:   Wed Feb 19 14:07:36 2014 +0800
>>
>>     iommu/vt-d: Unify the way to process DMAR device scope array
>>
>>     Now we have a PCI bus notification based mechanism to update DMAR
>>     device scope array, we could extend the mechanism to support boot
>>     time initialization too, which will help to unify and simplify
>>     the implementation.
>>
>>     Signed-off-by: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>     Signed-off-by: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
>
> My git bisect appears to be converging on something else, something
> within the hpsa patches that I sent up recently, unfortunately for
> me.  Will let you all know when it converges.
>

This smells very much like the problem that was solved couple of years
ago for SI domain. It is likely that path is broken with the DMAR
device scope array change. Please take a look to see if the following
no longer occurs. Looks like BIOS could be expecting this RMRR to be
still mapped.

               /*
                 * We want to prevent any device associated with an RMRR from
                 * getting placed into the SI Domain. This is done because
                 * problems exist when devices are moved in and out of domains
                 * and their respective RMRR info is lost. We exempt USB devices
                 * from this process due to their usage of RMRRs that are known
                 * to not be needed after BIOS hand-off to OS.
                 */
                if (device_has_rmrr(dev) &&
                    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
                        return 0;

-- Shuah
