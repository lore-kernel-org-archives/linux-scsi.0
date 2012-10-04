From: "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] scsi_transport_fc: Add sysfs entry for HBA
 API management library
Date: Thu, 4 Oct 2012 21:31:08 +0000
Message-ID: <506E0014.3000009@intel.com>
References: <20121003201237.28626.15887.stgit@fritz> <506D35FE.10202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <506D35FE.10202-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-US
Content-ID: <A2AD8B593605A742B0F0D2D98220BE23-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/4/2012 12:08 AM, Hannes Reinecke wrote:
> On 10/03/2012 10:12 PM, Robert Love wrote:
>> The user space HBA API vendor libraries need to know which HBA/CNAs
>> hosts to manage. Currently, libhbalinux is used to manage a few drivers
>> that use libfcoe and libfc. Right now libhbalinux keys off of the
>> string " over " in the FC Host's symbolic_name attribute to determine
>> if it should manage a given host. fnic, bnx2fc and fcoe/netdev based
>> hosts all use " over " in their symboic_names and that is currently
>> what libhbalinux looks for to determine if it should manage hosts
>> created by those drivers.
>>
>> Clearly using " over " in the symbolic_name isn't descriptive
>> and it is an awkward way to determine whether libhbalinux should
>> manage a host. Also, drivers may wish to use more descriptive
>> and accurate symbolic_names because these strings are displayed
>> in fabric management applications; forcing them to use " over "
>> in their symbolic_name is unnecessarily restrictive.
>>
>> This patch adds a read-only attribute to the FC Host that will expose
>> which management library should be used to manage it.
>>
>> This attribute will not be present in sysfs for drivers that
>> do no implement the .show_hbaapi_lib routine.
>>
>> Signed-off-by: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Tested-by: Ross Brattain <ross.b.brattain-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++++
>>   drivers/scsi/fcoe/fcoe.c          |    4 ++++
>>   drivers/scsi/fnic/fnic_main.c     |    4 ++++
>>   drivers/scsi/scsi_transport_fc.c  |    5 ++++-
>>   include/scsi/libfc.h              |    2 ++
>>   include/scsi/scsi_transport_fc.h  |    4 ++++
>>   6 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c 
>> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> index ae1cb76..97f60d8 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -731,6 +731,9 @@ static int bnx2fc_shost_config(struct fc_lport 
>> *lport, struct device *dev)
>>           BNX2FC_NAME, BNX2FC_VERSION,
>>           interface->netdev->name);
>>
>> +    strncpy(fc_host_hbaapi_library(lport->host), FC_LIBHBALINUX_NAME,
>> +        FC_SYMBOLIC_NAME_SIZE);
>> +
>>       return 0;
>>   }
>>
>> @@ -2583,6 +2586,7 @@ static struct fc_function_template 
>> bnx2fc_transport_function = {
>>       .get_host_port_state = fc_get_host_port_state,
>>       .show_host_port_state = 1,
>>       .show_host_symbolic_name = 1,
>> +    .show_host_hbaapi_library = 1,
>>
>>       .dd_fcrport_size = (sizeof(struct fc_rport_libfc_priv) +
>>                   sizeof(struct bnx2fc_rport)),
>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>> index 078d262..812876f 100644
>> --- a/drivers/scsi/fcoe/fcoe.c
>> +++ b/drivers/scsi/fcoe/fcoe.c
>> @@ -201,6 +201,7 @@ static struct fc_function_template 
>> fcoe_nport_fc_functions = {
>>       .get_host_port_state = fc_get_host_port_state,
>>       .show_host_port_state = 1,
>>       .show_host_symbolic_name = 1,
>> +    .show_host_hbaapi_library = 1,
>>
>>       .dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
>>       .show_rport_maxframe_size = 1,
>> @@ -755,6 +756,9 @@ static int fcoe_shost_config(struct fc_lport 
>> *lport, struct device *dev)
>>            "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
>>            fcoe_netdev(lport)->name);
>>
>> +    strncpy(fc_host_hbaapi_library(lport->host), FC_LIBHBALINUX_NAME,
>> +        FC_SYMBOLIC_NAME_SIZE);
>> +
>>       return 0;
>>   }
>>
>> diff --git a/drivers/scsi/fnic/fnic_main.c 
>> b/drivers/scsi/fnic/fnic_main.c
>> index fc98eb6..783bd3d 100644
>> --- a/drivers/scsi/fnic/fnic_main.c
>> +++ b/drivers/scsi/fnic/fnic_main.c
>> @@ -138,6 +138,7 @@ static struct fc_function_template 
>> fnic_fc_functions = {
>>       .get_host_port_state = fc_get_host_port_state,
>>       .show_host_port_state = 1,
>>       .show_host_symbolic_name = 1,
>> +    .show_host_hbaapi_library = 1,
>>       .show_rport_maxframe_size = 1,
>>       .show_rport_supported_classes = 1,
>>       .show_host_fabric_name = 1,
>> @@ -704,6 +705,9 @@ static int __devinit fnic_probe(struct pci_dev 
>> *pdev,
>>       sprintf(fc_host_symbolic_name(lp->host),
>>           DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
>>
>> +    strncpy(fc_host_hbaapi_library(lp->host), FC_LIBHBALINUX_NAME,
>> +        FC_SYMBOLIC_NAME_SIZE);
>> +
>>       spin_lock_irqsave(&fnic_list_lock, flags);
>>       list_add_tail(&fnic->list, &fnic_list);
>>       spin_unlock_irqrestore(&fnic_list_lock, flags);
>> diff --git a/drivers/scsi/scsi_transport_fc.c 
>> b/drivers/scsi/scsi_transport_fc.c
>> index e894ca7..ed19b42 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -313,7 +313,7 @@ static void fc_scsi_scan_rport(struct work_struct 
>> *work);
>>   #define FC_STARGET_NUM_ATTRS     3
>>   #define FC_RPORT_NUM_ATTRS    10
>>   #define FC_VPORT_NUM_ATTRS    9
>> -#define FC_HOST_NUM_ATTRS    29
>> +#define FC_HOST_NUM_ATTRS    30
>>
>>   struct fc_internal {
>>       struct scsi_transport_template t;
>> @@ -422,6 +422,7 @@ static int fc_host_setup(struct 
>> transport_container *tc, struct device *dev,
>>       fc_host->speed = FC_PORTSPEED_UNKNOWN;
>>       fc_host->fabric_name = -1;
>>       memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
>> +    memset(fc_host->hbaapi_library, 0, 
>> sizeof(fc_host->hbaapi_library));
>>       memset(fc_host->system_hostname, 0, 
>> sizeof(fc_host->system_hostname));
>>
>>       fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
>> @@ -1529,6 +1530,7 @@ fc_private_host_rd_attr(max_npiv_vports, 
>> "%u\n", 20);
>>   fc_private_host_rd_attr(serial_number, "%s\n", 
>> (FC_SERIAL_NUMBER_SIZE +1));
>>   fc_private_host_rd_attr(manufacturer, "%s\n", FC_SERIAL_NUMBER_SIZE 
>> + 1);
>>   fc_private_host_rd_attr(model, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
>> +fc_private_host_rd_attr(hbaapi_library, "%s\n", 
>> FC_SYMBOLIC_NAME_SIZE + 1);
>>   fc_private_host_rd_attr(model_description, "%s\n", 
>> FC_SYMBOLIC_NAME_SIZE + 1);
>>   fc_private_host_rd_attr(hardware_version, "%s\n", 
>> FC_VERSION_STRING_SIZE + 1);
>>   fc_private_host_rd_attr(driver_version, "%s\n", 
>> FC_VERSION_STRING_SIZE + 1);
>> @@ -2262,6 +2264,7 @@ fc_attach_transport(struct fc_function_template 
>> *ft)
>>       SETUP_HOST_ATTRIBUTE_RD(speed);
>>       SETUP_HOST_ATTRIBUTE_RD(fabric_name);
>>       SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
>> +    SETUP_HOST_ATTRIBUTE_RD(hbaapi_library);
>>       SETUP_HOST_ATTRIBUTE_RW(system_hostname);
>>
>>       /* Transport-managed attributes */
>> diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
>> index 399162b..89630cf 100644
>> --- a/include/scsi/libfc.h
>> +++ b/include/scsi/libfc.h
>> @@ -36,6 +36,8 @@
>>
>>   #include <scsi/fc_frame.h>
>>
>> +#define FC_LIBHBALINUX_NAME "libhbalinux"
>> +
>>   #define    FC_FC4_PROV_SIZE    (FC_TYPE_FCP + 1)    /* size of 
>> tables */
>>
>>   /*
> Bah.
>
> You can't be serious.
> I totally agree that matching on 'over' is ridiculous.
> But hard-coding 'libhbalinux' is also a bad move, simply for the fact 
> that libhbalinux is a user-space library and no-one knows how long 
> it'll stay around. Or if some vendor would like it to be renamed for 
> whatever reason.
>

OK, point taken. I can't say I'm too surprised I got flamed for this 
one. :) However, as you agree, there is a real problem to solve.

> No, please. I would rather define a libfc version, and having this one 
> displayed fc host attributes.
> This way userspace could identify
> a) if libfc is used
> b) which libfc _version_ is used
> and libbhalinux could match onto those.
>

So, this is not good enough. The question I am trying to answer is, "How 
does a management library know which fc_host it should manage?" A libfc 
version would only tell me who is using libfc and which version. This 
could include a HBA/CNA that uses libfc (kernel), but noes not use 
libhbalinux (user).

I'd further contend that the kernel is already reporting this 
information and in string form. It's just using a string that carries no 
context: " over ", which really tells you nothing useful. The current 
patch simply adds context to the string by moving it to be a new attribute.

What if I keep the hbaapi_library attribute on the fc_host, but I make 
it RW and set it to "" by default. This would allow something in user 
space to set the HBA API management library to be used. For example, 
fcoemon could start fcoe on a interface and then set the management 
library for that interface. Alternatively, an HBA/CNA install script/app 
could do the same. This would allow the driver to report which library 
should be used, but the decision making stays in user space.

One last thought on the RW hbaapi_library idea. There is a timing 
problem, which is that the current fcoe "control" interface 
discovery/login happens on creation, so the name of the mgmt library 
won't get set until sometime during the interface discovery/login phase. 
My new fcoe_sysfs based interfaces allow for a configuration pause 
before discover/login, which would solve that minor timing issue. So, in 
my mind this would fit in nicely with the interface change that I'm 
proposing in another thread.

Thoughts?

Thanks, //Rob
