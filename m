From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] declare and export scsi_bus_type
Date: Thu, 12 Dec 2002 10:16:40 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0212121006520.976-100000@localhost.localdomain>
References: <200212121358.gBCDw2b01977@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200212121358.gBCDw2b01977@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Domsch <Matt_Domsch@Dell.com>, linux-scsi@vger.kernel.org


Didn't see this before I replied.. 

On Thu, 12 Dec 2002, James Bottomley wrote:

> hch@infradead.org said:
> > I'm very unhappy with exporting random parts of the scsi midlayer.  In
> > what way do you need it?  How does your code work with modular scsi? 
> 
> Convention tends to be that these bus types are exported.  That's certainly 
> true for pci and mca.
> 
> However, perhaps we should have a better way of finding them than by direct 
> export of the symbol.  Since each bus is required to have a unique name, and 
> the sysfs system has an internal list of bus_types, we could have a function 
> which takes the name and returns a pointer to the bus_type if it exists?

Yes, the following patch should work. There are two caveats, AFAICT

- Making sure that we have a consistent name. This could resolved by adding 
  something like

  #define SCSI_BUS_NAME "scsi"

  to include/scsi.h/scsi.h..

- Accessing a bus type is O(n) rather that O(1). OTOH, it's not peformance 
  critical code, and there can't be very many bus types registered at once, 
  so it shouldn't be noticable. 


	-pat

===== drivers/base/bus.c 1.27 vs edited =====
--- 1.27/drivers/base/bus.c	Thu Dec  5 22:33:28 2002
+++ edited/drivers/base/bus.c	Thu Dec 12 10:09:32 2002
@@ -466,6 +466,29 @@
 	}
 }
 
+
+/**
+ *	find_bus - search for a bus type by name.
+ *	@name:	name of the bus.
+ */
+
+struct bus_type * find_bus(const char * name)
+{
+	struct list_head * entry;
+	struct bus_type * ret = NULL;
+
+	down_read(&bus_subsys.rwsem);
+	list_for_each(entry,&bus_subsys.list) {
+		struct bus_type * b = list_entry(entry,struct bus_type,subsys.kobj.entry);
+		if (!strncmp(b->subsys.kobj.name,name,KOBJ_NAME_LEN)) {
+			ret = b;
+			break;
+		}
+	}
+	up_read(&bus_subsys.rwsem);
+	return ret;
+}
+
 struct bus_type * get_bus(struct bus_type * bus)
 {
 	return bus ? container_of(subsys_get(&bus->subsys),struct bus_type,subsys) : NULL;
@@ -537,6 +560,7 @@
 EXPORT_SYMBOL(bus_remove_device);
 EXPORT_SYMBOL(bus_register);
 EXPORT_SYMBOL(bus_unregister);
+EXPORT_SYMBOL(find_bus);
 EXPORT_SYMBOL(get_bus);
 EXPORT_SYMBOL(put_bus);
 
===== include/linux/device.h 1.68 vs edited =====
--- 1.68/include/linux/device.h	Tue Dec  3 12:40:21 2002
+++ edited/include/linux/device.h	Thu Dec 12 10:09:23 2002
@@ -81,6 +81,8 @@
 extern int bus_register(struct bus_type * bus);
 extern void bus_unregister(struct bus_type * bus);
 
+extern struct bus_type * find_bus(const char * name);
+
 extern struct bus_type * get_bus(struct bus_type * bus);
 extern void put_bus(struct bus_type * bus);
 

