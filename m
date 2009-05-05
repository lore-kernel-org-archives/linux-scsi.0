From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: Patch - To display FCoE Host information and statistics in sysfs
Date: Tue, 5 May 2009 00:07:14 -0700
Message-ID: <9A68A60D-0D14-41F1-B0A1-125294A5438C@qlogic.com>
References: <B1CF29D0-32EB-4340-BAA1-B1B13A2BA2FF@qlogic.com> <0DC3E4D6-2BD9-4A1B-9A70-5395FEAC1F04@qlogic.com> <49F9D93A.9070906@emulex.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45523 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZEEHHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 03:07:15 -0400
In-Reply-To: <49F9D93A.9070906@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

James,

By opening the FC as a bus, you meant a sysfs layout similar to  
present scsi layout in 2.6 kernel (/sys/bus/scsi).

Below are the layout details that I had in my mind
/sys/bus/fc/devices/ - list of all devices
/sys/bus/fc/drivers/fc and fcoe ( links to all fc and fcoe hosts and  
targets )
/sys/class/fc/fc_host/
/sys/class/fc/fc_remote_ports
/sys/class/fc/fcoe_host ( Initiator )
/sys/class/fc/fcoe_remote_ports ( Target )

Please comment whether I understood it right?

	This makes things lot clear for me. This conveys better distinction  
between FC and FCoE adapters present in the system. The FC and FCoE  
specific details can be kept under respective directory and links can  
be created to map their relations.

	As stated by you, the scope of these changes looks bit heavy. I feel,  
it will be good to add these changes incrementally. Keeping long term  
perspective, is it a good idea to add FCoE related information as a  
separate directory parallel to fc_host in /sys/class directory. I feel  
this leads to easier migration when FC is opened up as a bus in future.

Thanks,
Giridhar.M.B


On Apr 30, 2009, at 10:00 AM, James Smart wrote:

> Giridhar,
>
> Yes I saw it. I'm really a little unsure. At LSF, we talked about the
> need for FC to open up as a bus, thus change the way the topology
> objects are created, and FCOE affects that as the attributes are
> pre-role (role being initiator or tgt or whatever) but where you are
> placing them is in a role-based location.  So, if we say yes, as the  
> set
> is rather small, then it starts us off on a divergence from this
> longer-term view. Yes, we can survive, but I hate telling mgmt code to
> deal with both variants in the future.
>
> -- james
>
>
>
> Giridhar Malavali wrote:
>> Hi James,
>>
>> I had submitted the following patch last week. I did not hear any
>> thing from you or from the community. Just a friendly check to find
>> out whether this patch looks fine?
>>
>> Thanks,
>> Giridhar.M.B
>>
>>
>>
>>
>>
>> Begin forwarded message:
>>
>>
>>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>> Date: April 17, 2009 6:01:30 PM PDT
>>> To: James Smart <James.Smart@Emulex.Com>
>>> Cc: linux-scsi@vger.kernel.org
>>> Subject: Patch - To display FCoE Host information and statistics in
>>> sysfs
>>>
>>> Hi All,
>>>
>>> Attached is the patch for displaying FCoE Host bus adapter
>>> information in sysfs.
>>>
>>> This patch adds fcoe directory (/sys/class/fc_host/hostX/fcoe) and a
>>> statistics sub-directory (/sys/class/fc_host/hostX/fcoe/statistics)
>>> to display FCoE host specific and it statistics respectively.
>>>
>>> A new port type definition called VF_PORT (Virtual Fabric Port) is
>>> added to identify the virtual link between ENode and the FCF switch.
>>> The contents in the fcoe and its sub-directory will be valid, if the
>>> FC port type is a VF_PORT.
>>>
>>> Following are the members added to display host specific information
>>> under /sys/class/fc_host/hostX/fcoe directory
>>>
>>>      1) enode_mac_address - The burnt in MAC address used by the  
>>> FCoE
>>> adapter
>>>      2) vn_port_mac_address - The current MAC address used by the  
>>> FCoE
>>> adapter. This can be same as ENode MAC address or different based on
>>> the MAC               addressing mode.
>>>      3) vf_port_mac_address - MAC address of the FCF.
>>>      4) mac_addressing_mode - The type of FCoE MAC addressing mode
>>>              FCF_SELECTED - The FCF selects either SPMA or FPMA  
>>> addressing mode
>>>              SPMA_ONLY - Only SPMA addressing mode is supported by  
>>> ENode
>>>              FPMA_ONLY - Only FPMA addressing mode is supported by  
>>> ENode
>>>              SPMA_PREFERRED - SPMA addressing mode is preferred by  
>>> ENode
>>>              FPMA_PREFERRED - FPMA addressing mode is preferred by  
>>> ENode
>>>      5) vlan_id - The Vlan ID used
>>>
>>> Following counters are added to display host statistics information
>>> under /sys/class/fc_host/hostX/fcoe/statistics directory
>>>
>>>      The statistics information displayed is similar to FC host
>>> statistics. The FCoE statistics carries the same naming as FC host
>>> statistics but the information displayed are mapped to related MAC
>>> statistics.
>>>
>>>      This information is based on the proposal made to T11 for  
>>> mapping
>>> FC LESB ( Link Error Status Block) to FC_BB_E. Please refer to FCoE
>>> Link Error Status Block (09-204v1.pdf) document  at www.t11.org/index.html
>>> .
>>>
>>> The various counters are
>>>
>>>      1) Invalid_crc_count
>>>      2) Invalid_tx_word_count
>>>      3) link_failure_count
>>>      4) loss_of_signal_count
>>>      5) loss_of_sync_count
>>>      6) prim_seq_protocol_error.
>>>
>>> Thanks,
>>> Giridhar.M.B
>>>
>>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>> Date: Fri, 17 Apr 2009 15:51:42 -0700
>>> Subject: [PATCH 1/2] Addition of FCoE information to sysfs.
>>>
>>> The information contains both FCoE host specific as well as its
>>> statistics.
>>> The FCoE specific information are displayed under /sys/class/ 
>>> fc_host/
>>> hostX/fcoe
>>> and /sys/class/fc_host/hostX/fcoe/statistics directories  
>>> respectively.
>>>
>>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>> ---
>>> drivers/scsi/scsi_transport_fc.c |  292 +++++++++++++++++++++++++++ 
>>> ++
>>> ++++-----
>>> include/scsi/scsi_transport_fc.h |   53 +++++++
>>> 2 files changed, 311 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
>>> scsi_transport_fc.c
>>> index a152f89..55e3757 100644
>>> --- a/drivers/scsi/scsi_transport_fc.c
>>> +++ b/drivers/scsi/scsi_transport_fc.c
>>> @@ -44,6 +44,18 @@ static int fc_vport_setup(struct Scsi_Host
>>> *shost, int channel,
>>>      struct device *pdev, struct fc_vport_identifiers  *ids,
>>>      struct fc_vport **vport);
>>>
>>> +/* Kobjects for /sys/class/fc_host/hostx/fcoe
>>> + * and /sys/class/fc_host/hostx/fcoe/statistics objects
>>> + */
>>> +struct kobject *private_fcoe_kobj;
>>> +struct kobject *private_fcoe_stat_kobj;
>>> +
>>> +/* Kobject attributes defined for /sys/class/fc_host/hostx/fcoe
>>> + * and /sys/class/fc_host/hostx/fcoe/statistics objects
>>> + */
>>> +#define  
>>> FCOE_KOBJECT_ATTR(_prefix,_name,_mode,_show,_store)          \
>>> +struct kobj_attribute kobject_attr_##_prefix##_##_name  
>>> =             \
>>> +     __ATTR(_name,_mode,_show,_store)
>>> /*
>>> * Redefine so that we can have same named attributes in the
>>> * sdev/starget/host objects.
>>> @@ -97,6 +109,7 @@ static struct {
>>>      { FC_PORTTYPE_LPORT,    "LPort (private loop)" },
>>>      { FC_PORTTYPE_PTP,      "Point-To-Point (direct nport  
>>> connection)" },
>>>      { FC_PORTTYPE_NPIV,             "NPIV VPORT" },
>>> +     { FC_PORTTYPE_VFPORT,           "VFPort (Virtual fabric via  
>>> point-to-
>>> point)" },
>>> };
>>> fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
>>> #define FC_PORTTYPE_MAX_NAMELEN               50
>>> @@ -414,12 +427,6 @@ static int fc_host_setup(struct
>>> transport_container *tc, struct device *dev,
>>>      return 0;
>>> }
>>>
>>> -static DECLARE_TRANSPORT_CLASS(fc_host_class,
>>> -                            "fc_host",
>>> -                            fc_host_setup,
>>> -                            NULL,
>>> -                            NULL);
>>> -
>>> /*
>>> * Setup and Remove actions for remote ports are handled
>>> * in the service functions below.
>>> @@ -617,34 +624,6 @@ send_vendor_fail:
>>> }
>>> EXPORT_SYMBOL(fc_host_post_vendor_event);
>>>
>>> -
>>> -
>>> -static __init int fc_transport_init(void)
>>> -{
>>> -     int error;
>>> -
>>> -     atomic_set(&fc_event_seq, 0);
>>> -
>>> -     error = transport_class_register(&fc_host_class);
>>> -     if (error)
>>> -             return error;
>>> -     error = transport_class_register(&fc_vport_class);
>>> -     if (error)
>>> -             return error;
>>> -     error = transport_class_register(&fc_rport_class);
>>> -     if (error)
>>> -             return error;
>>> -     return transport_class_register(&fc_transport_class);
>>> -}
>>> -
>>> -static void __exit fc_transport_exit(void)
>>> -{
>>> -     transport_class_unregister(&fc_transport_class);
>>> -     transport_class_unregister(&fc_rport_class);
>>> -     transport_class_unregister(&fc_host_class);
>>> -     transport_class_unregister(&fc_vport_class);
>>> -}
>>> -
>>> /*
>>> * FC Remote Port Attribute Management
>>> */
>>> @@ -1655,6 +1634,224 @@ static struct attribute_group
>>> fc_statistics_group = {
>>>      .attrs = fc_statistics_attrs,
>>> };
>>>
>>> +/*
>>> + * FCoE Host attributes
>>> + */
>>> +
>>> +/* Convert mac_addressing_mode values to ascii string name */
>>> +static struct {
>>> +     enum fcoe_mac_addressing_mode value;
>>> +     char                    *name;
>>> +} mac_addressing_mode_names [] = {
>>> +     { FCF_SELECTED,                 "FCF selcted - Either FPMA  
>>> or SPMA" },
>>> +     { SPMA_ONLY,                    "SPMA only - ENode Solicites  
>>> SPMA only support" },
>>> +     { FPMA_ONLY,                    "FPMA only - ENode Solicites  
>>> SPMA only support" },
>>> +     { SPMA_PREFERRED,               "SPMA preferred - ENode  
>>> Solicites SPMA
>>> preferred support" },
>>> +     { FPMA_PREFERRED,               "FPMA preferred - ENode  
>>> Solicites FPMA
>>> preferred support" },
>>> +};
>>> +fc_enum_name_search(mac_addressing_mode, fcoe_mac_addressing_mode,
>>> mac_addressing_mode_names)
>>> +#define FCOE_MAC_ADDR_MODE_MAX_NAMELEN       80
>>> +
>>> +/* Show MAC address members of the FCoE host attributes */
>>> +static ssize_t
>>> +fcoe_host_attrs_show(const struct kobject *kobj, char *buf,
>>> unsigned long offset)
>>> +{
>>> +     struct device *dev = kobj_to_dev(kobj->parent);
>>> +     struct Scsi_Host *shost = transport_class_to_shost(dev);
>>> +     struct fc_internal *i = to_fc_internal(shost->transportt);
>>> +     struct fcoe_host_attrs *stats;
>>> +     ssize_t ret = -ENOENT;
>>> +
>>> +     if (i->f->get_fcoe_host) {
>>> +             stats = (i->f->get_fcoe_host)(shost);
>>> +             if (stats)
>>> +                     ret = snprintf(buf, 20, "0x%x\n",
>>> +                           *(u16 *)(((u8 *) stats) + offset));
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +/* generate a read-only FCoE Host attribute */
>>> +#define  
>>> fcoe_host_attrs 
>>> (name)                                                \
>>> +static ssize_t show_fcoe_host_attrs_##name(struct kobject  
>>> *cd,               \
>>> +                               struct kobj_attribute  
>>> *attr,          \
>>> +                               char  
>>> *buf)                            \
>>> + 
>>> {                                                                    \
>>> +     return fcoe_host_attrs_show(cd,  
>>> buf,                            \
>>> +                         offsetof(struct fcoe_host_attrs,  
>>> name));    \
>>> + 
>>> }                                                                    \
>>> +static FCOE_KOBJECT_ATTR(fcoe, name, S_IRUGO,
>>> show_fcoe_host_attrs_##name, NULL)
>>> +
>>> +fcoe_host_attrs(vlan_id);
>>> +
>>> +#define fcoe_host_attrs_enum_attr(title,  
>>> maxlen)                     \
>>> +static ssize_t show_fcoe_host_attrs_##title(struct kobject  
>>> *kobj,    \
>>> +                               struct kobj_attribute  
>>> *attr,          \
>>> +                               char  
>>> *buf)                            \
>>> + 
>>> {                                                                    \
>>> +     struct device *dev = kobj_to_dev(kobj- 
>>> >parent);                 \
>>> +     struct Scsi_Host *shost =  
>>> transport_class_to_shost(dev);        \
>>> +     struct fc_internal *i = to_fc_internal(shost- 
>>> >transportt);      \
>>> +     struct fcoe_host_attrs  
>>> *stats;                                  \
>>> +     ssize_t ret = - 
>>> EINVAL;                                          \
>>> +     const char  
>>> *name;                                               \
>>> + 
>>>                                                                      \
>>> +     if (i->f->get_fcoe_host)  
>>> {                                      \
>>> +             stats = (i->f->get_fcoe_host) 
>>> (shost);                   \
>>> +             if(stats)  
>>> {                                             \
>>> +                     name = get_fc_##title##_name(stats- 
>>> >mac_addressing_mode);       \
>>> +                     if  
>>> (name)                                                       \
>>> +                             ret= snprintf(buf, maxlen, "%s\n",  
>>> name);               \
>>> + 
>>>              }                                                                       \
>>> + 
>>>      }                                                                               \
>>> +     return  
>>> ret 
>>> ;                                                                     \
>>> + 
>>> }                                                                                    \
>>> +static FCOE_KOBJECT_ATTR(fcoe, title, S_IRUGO,
>>> show_fcoe_host_attrs_##title, NULL)
>>> +
>>> +fcoe_host_attrs_enum_attr(mac_addressing_mode,
>>> FCOE_MAC_ADDR_MODE_MAX_NAMELEN);
>>> +
>>> +static ssize_t
>>> +fcoe_mac_addr_show(const struct kobject *kobj, char *buf, unsigned
>>> long offset)
>>> +{
>>> +     struct device *dev = kobj_to_dev(kobj->parent);
>>> +     struct Scsi_Host *shost = transport_class_to_shost(dev);
>>> +     struct fc_internal *i = to_fc_internal(shost->transportt);
>>> +     struct fcoe_host_attrs *stats;
>>> +     ssize_t ret = -ENOENT;
>>> +
>>> +     if (offset > sizeof(struct fcoe_host_attrs))
>>> +             WARN_ON(1);
>>> +
>>> +     if (i->f->get_fcoe_host) {
>>> +             stats = (i->f->get_fcoe_host)(shost);
>>> +             if (stats) {
>>> +                     u8 *macaddr = (u8*)(((u8 *) stats) + offset);
>>> +                     ret = sysfs_format_mac(buf, macaddr, 6);
>>> +             }
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +/* generate a read-only FCoE MAC address host attribute */
>>> +#define  
>>> fcoe_mac_addr(name)                                          \
>>> +static ssize_t show_fcoe_mac_addr_##name(struct kobject  
>>> *cd,         \
>>> +                               struct kobj_attribute  
>>> *attr,          \
>>> +                               char  
>>> *buf)                            \
>>> + 
>>> {                                                                    \
>>> +     return fcoe_mac_addr_show(cd,  
>>> buf,                              \
>>> +                         offsetof(struct fcoe_host_attrs,  
>>> name));    \
>>> + 
>>> }                                                                    \
>>> +static FCOE_KOBJECT_ATTR(fcoe, name, S_IRUGO,
>>> show_fcoe_mac_addr_##name, NULL)
>>> +
>>> +fcoe_mac_addr(enode_mac_address);
>>> +fcoe_mac_addr(vn_port_mac_address);
>>> +fcoe_mac_addr(vf_port_mac_address);
>>> +
>>> +static struct attribute *fcoe_host_attrs[] = {
>>> +     &kobject_attr_fcoe_enode_mac_address.attr,
>>> +     &kobject_attr_fcoe_vn_port_mac_address.attr,
>>> +     &kobject_attr_fcoe_vf_port_mac_address.attr,
>>> +     &kobject_attr_fcoe_vlan_id.attr,
>>> +     &kobject_attr_fcoe_mac_addressing_mode.attr,
>>> +     NULL
>>> +};
>>> +
>>> +static struct attribute_group fcoe_host_attrs_group = {
>>> +     .attrs = fcoe_host_attrs,
>>> +};
>>> +
>>> +/* Read FCoE host statistics */
>>> +static ssize_t
>>> +fcoe_host_statistics_show(const struct kobject *kobj, char *buf,
>>> unsigned long offset)
>>> +{
>>> +     struct device *dev = kobj_to_dev(kobj->parent->parent);
>>> +     struct Scsi_Host *shost = transport_class_to_shost(dev);
>>> +     struct fc_internal *i = to_fc_internal(shost->transportt);
>>> +     struct fcoe_host_statistics *stats;
>>> +     ssize_t ret = -ENOENT;
>>> +
>>> +     if (offset > sizeof(struct fcoe_host_statistics) ||
>>> +         offset % sizeof(u64) != 0)
>>> +             WARN_ON(1);
>>> +
>>> +     if (i->f->get_fcoe_host_stats) {
>>> +             stats = (i->f->get_fcoe_host_stats)(shost);
>>> +             if (stats)
>>> +                     ret = snprintf(buf, 20, "0x%llx\n",
>>> +                           (unsigned long long)*(u64 *)(((u8 *)  
>>> stats) + offset));
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +/* generate a read-only FCoE host staistics attribute */
>>> +#define  
>>> fcoe_host_statistics 
>>> (name)                                           \
>>> +static ssize_t show_fcoe_host_statistics_##name(struct kobject
>>> *cd,          \
>>> +                               struct kobj_attribute  
>>> *attr,                  \
>>> +                               char  
>>> *buf)                                    \
>>> + 
>>> {                                                                            \
>>> +     return fcoe_host_statistics_show(cd,  
>>> buf,                               \
>>> +                         offsetof(struct fcoe_host_statistics,  
>>> name));       \
>>> + 
>>> }                                                                            \
>>> +static FCOE_KOBJECT_ATTR(fcoe, name, S_IRUGO,
>>> show_fcoe_host_statistics_##name, NULL)
>>> +
>>> +fcoe_host_statistics(link_failure_count);
>>> +fcoe_host_statistics(loss_of_sync_count);
>>> +fcoe_host_statistics(loss_of_signal_count);
>>> +fcoe_host_statistics(prim_seq_protocol_err_count);
>>> +fcoe_host_statistics(invalid_tx_word_count);
>>> +fcoe_host_statistics(invalid_crc_count);
>>> +
>>> +static struct attribute *fcoe_host_statistics[] = {
>>> +     &kobject_attr_fcoe_link_failure_count.attr,
>>> +     &kobject_attr_fcoe_loss_of_sync_count.attr,
>>> +     &kobject_attr_fcoe_loss_of_signal_count.attr,
>>> +     &kobject_attr_fcoe_prim_seq_protocol_err_count.attr,
>>> +     &kobject_attr_fcoe_invalid_tx_word_count.attr,
>>> +     &kobject_attr_fcoe_invalid_crc_count.attr,
>>> +     NULL
>>> +};
>>> +
>>> +static struct attribute_group fcoe_host_statistics_group = {
>>> +     .attrs = fcoe_host_statistics,
>>> +};
>>> +
>>> +static int fc_host_configure(struct transport_container *tc, struct
>>> device *dev,
>>> +                      struct device *cdev)
>>> +{
>>> +     int error;
>>> +
>>> +     /* Create a fcoe sub-directory under /sys/class/fc_host/ 
>>> hostX/ */
>>> +     private_fcoe_kobj = kobject_create_and_add("fcoe", &cdev- 
>>> >kobj);
>>> +     if (private_fcoe_kobj) {
>>> +             /* Create the files associated with this kobject */
>>> +             error = sysfs_create_group(private_fcoe_kobj,
>>> &fcoe_host_attrs_group);
>>> +             if (error) {
>>> +                     kobject_put(private_fcoe_kobj);
>>> +                     goto error;
>>> +             }
>>> +     }
>>> +
>>> +     /* Create a statistics sub-directory under /sys/class/fc_host/
>>> hostX/fcoe/ */
>>> +     private_fcoe_stat_kobj = kobject_create_and_add("statistics",
>>> private_fcoe_kobj);
>>> +     if (private_fcoe_stat_kobj) {
>>> +             /* Create the files associated with this kobject */
>>> +             error = sysfs_create_group(private_fcoe_stat_kobj,
>>> &fcoe_host_statistics_group);
>>> +             if (error) {
>>> +                     kobject_put(private_fcoe_stat_kobj);
>>> +                     goto error;
>>> +             }
>>> +     }
>>> +
>>> +error:
>>> +     return 0;
>>> +}
>>> +
>>> +static DECLARE_TRANSPORT_CLASS(fc_host_class,
>>> +                            "fc_host",
>>> +                            fc_host_setup,
>>> +                            NULL,
>>> +                            fc_host_configure);
>>> +
>>>
>>> /* Host Vport Attributes */
>>>
>>> @@ -3342,6 +3539,33 @@ fc_vport_sched_delete(struct work_struct  
>>> *work)
>>>                      vport->channel, stat);
>>> }
>>>
>>> +static __init int fc_transport_init(void)
>>> +{
>>> +     int error;
>>> +
>>> +     atomic_set(&fc_event_seq, 0);
>>> +
>>> +     error = transport_class_register(&fc_host_class);
>>> +     if (error)
>>> +             return error;
>>> +     error = transport_class_register(&fc_vport_class);
>>> +     if (error)
>>> +             return error;
>>> +     error = transport_class_register(&fc_rport_class);
>>> +     if (error)
>>> +             return error;
>>> +     return transport_class_register(&fc_transport_class);
>>> +}
>>> +
>>> +static void __exit fc_transport_exit(void)
>>> +{
>>> +     transport_class_unregister(&fc_transport_class);
>>> +     transport_class_unregister(&fc_rport_class);
>>> +     transport_class_unregister(&fc_host_class);
>>> +     transport_class_unregister(&fc_vport_class);
>>> +     kobject_put(private_fcoe_kobj);
>>> +     kobject_put(private_fcoe_stat_kobj);
>>> +}
>>>
>>> /* Original Author:  Martin Hicks */
>>> MODULE_AUTHOR("James Smart");
>>> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/
>>> scsi_transport_fc.h
>>> index c9184f7..def2e23 100644
>>> --- a/include/scsi/scsi_transport_fc.h
>>> +++ b/include/scsi/scsi_transport_fc.h
>>> @@ -30,6 +30,8 @@
>>> #include <linux/sched.h>
>>> #include <scsi/scsi.h>
>>> #include <scsi/scsi_netlink.h>
>>> +#include <scsi/scsi_netlink.h>
>>> +#include <linux/etherdevice.h>
>>>
>>> struct scsi_transport_template;
>>>
>>> @@ -63,6 +65,7 @@ enum fc_port_type {
>>>      FC_PORTTYPE_LPORT,              /* (Private) Loop w/o FLPort */
>>>      FC_PORTTYPE_PTP,                /* Point to Point w/ another  
>>> NPort */
>>>      FC_PORTTYPE_NPIV,               /* VPORT based on NPIV */
>>> +     FC_PORTTYPE_VFPORT,             /* Virtual Fabric PORT */
>>> };
>>>
>>>
>>> @@ -428,6 +431,53 @@ struct fc_host_statistics {
>>>      u64 fcp_output_megabytes;
>>> };
>>>
>>> +/*
>>> + * FCoE Local Port (Host) Attributes
>>> + *
>>> + * Fixed attributes are not expected to change. The driver is
>>> + * expected to set these values after successfully calling
>>> scsi_add_host().
>>> + * The transport fully manages all get functions w/o driver
>>> interaction.
>>> + *
>>> + * Dynamic attributes are expected to change. The driver  
>>> participates
>>> + * in all get/set operations via functions provided by the driver.
>>> + *
>>> + */
>>> +struct fcoe_host_attrs {
>>> +     /* Fixed attributes */
>>> +     uint8_t enode_mac_address[ETH_ALEN];
>>> +
>>> +     /* Dynamic attributes */
>>> +     uint8_t vn_port_mac_address[ETH_ALEN];
>>> +     uint8_t vf_port_mac_address[ETH_ALEN];
>>> +     u16 vlan_id;
>>> +     u16 mac_addressing_mode;
>>> +};
>>> +
>>> +/* FCoE Statistics - Following proposal for FC_BB_E FC Link error
>>> status block representation
>>> + * from T11/09-204v0 guidelines
>>> + */
>>> +struct fcoe_host_statistics {
>>> +     /* Port statistics */
>>> +     u64 link_failure_count;
>>> +     u64 loss_of_sync_count;
>>> +     u64 loss_of_signal_count;
>>> +     u64 prim_seq_protocol_err_count;
>>> +     u64 invalid_tx_word_count;
>>> +     u64 invalid_crc_count;
>>> +};
>>> +
>>> +
>>> +/*
>>> + * mac_addressing_mode: If you alter this, you also need to alter
>>> + * scsi_transport_fc.c (for the ascii descriptions).
>>> + */
>>> +enum fcoe_mac_addressing_mode {
>>> +     FCF_SELECTED,
>>> +     SPMA_ONLY,
>>> +     FPMA_ONLY,
>>> +     SPMA_PREFERRED,
>>> +     FPMA_PREFERRED,
>>> +};
>>>
>>> /*
>>> * FC Event Codes - Polled and Async, following FC HBAAPI v2.0
>>> guidelines
>>> @@ -600,6 +650,9 @@ struct fc_function_template {
>>>      struct fc_host_statistics * (*get_fc_host_stats)(struct  
>>> Scsi_Host *);
>>>      void    (*reset_fc_host_stats)(struct Scsi_Host *);
>>>
>>> +     struct fcoe_host_attrs* (*get_fcoe_host)(struct Scsi_Host *);
>>> +     struct fcoe_host_statistics* (*get_fcoe_host_stats)(struct
>>> Scsi_Host *);
>>> +
>>>      int     (*issue_fc_host_lip)(struct Scsi_Host *);
>>>
>>>      void    (*dev_loss_tmo_callbk)(struct fc_rport *);
>>> --
>>> 1.6.2.rc1.30.gd43c
>>>
>>>
>>>
>>>
>>>
>>>
>>
>>
>>

